bl_info = {
	"name": "Export Binary (.model)",
	"author": "John Stricker (modified from Jeff LaMarche's C Header script",
	"location": "File > Export",
	"description": "Export Model Verts, Norms, & Texture Coords to Binary File",
	"category": "Import-Export"}

import bpy
from bpy.props import *
import mathutils, math, struct, time
import bpy_extras
from bpy_extras.io_utils import ExportHelper

def do_export(context, props, filepath):

	scene = bpy.context.scene
	bpy.ops.object.mode_set(mode='OBJECT')
	obj = bpy.context.active_object
	
	#apply modifiers if requested
	if props.apply_modifiers:
		for i in range(0,len(obj.modifiers)):
			name = obj.modifiers[i].name
			bpy.ops.object.modifier_apply(modifier=name)

	bpy.ops.object.mode_set(mode='EDIT')
	bpy.ops.mesh.select_all(action='SELECT')

	#perform mesh modifications if requested
	if props.convert_to_tris:
		bpy.ops.mesh.quads_convert_to_tris()
	if props.world_space:
		obj.data.transform(ob.matrix_world)
	if props.rot_x90:
		mat_x90 = mathutils.Matrix.Rotation(-math.pi/2, 4, 'X')
		obj.data.transform(mat_x90)

	bpy.ops.object.mode_set(mode='OBJECT')

	obj.data.update(calc_tessface = True)
		#make sure that UV's have been applied
	if len(obj.data.tessface_uv_textures) < 1:
		print("UV coordinates were not found! Did you unwrap your mesh?")
		return False

	if len(obj.data.tessface_uv_textures) > 0:
		file = open(filepath, "wb") 
		file.write(struct.pack('<i',len(obj.data.tessfaces)))
		#for face in uv: loop through the faces
		uv_layer = obj.data.tessface_uv_textures.active
		for face in obj.data.tessfaces:
			faceUV = uv_layer.data[face.index]
			i=0
			for index in face.vertices:
				if len(face.vertices) == 3:
					vert = obj.data.vertices[index]
					data = struct.pack('<ffffffff',
						vert.co.x,
						vert.co.y,
						vert.co.z,
						vert.normal.x,
						vert.normal.y,
						vert.normal.z,
						faceUV.uv[i][0],
						faceUV.uv[i][1])
					file.write(data)
					i+=1
		file.flush()
		file.close()

	bpy.ops.object.mode_set(mode='OBJECT')

	return True

	###### EXPORT OPERATOR #######
class Export_objc(bpy.types.Operator, ExportHelper):
	'''Exports the active Object as a binary .model file.'''
	bl_idname = "export_object.objc"
	bl_label = "Export Binary (.model)"
	filename_ext = ".model"
	
	apply_modifiers = BoolProperty(name="Apply Modifiers",
							description="Applies the Modifiers",
							default=True)

	rot_x90 = BoolProperty(name="Convert to Y-up",
							description="Rotate 90 degrees around X to convert to y-up",
							default=False)
	
	world_space = BoolProperty(name="Export into Worldspace",
							description="Transform the Vertexcoordinates into Worldspace",
							default=False)

	convert_to_tris = BoolProperty(name="Convert quads to triangles",
							description="Convert the mesh's quads to tris",
							default =True)
	
	@classmethod
	def poll(cls, context):
		return context.active_object.type in ['MESH', 'CURVE', 'SURFACE', 'FONT']

	def execute(self, context):
		start_time = time.time()
		print('\n_____START_____')
		props = self.properties
		filepath = self.filepath
		filepath = bpy.path.ensure_ext(filepath, self.filename_ext)

		exported = do_export(context, props, filepath)
		
		if exported:
			print('finished export in %s seconds' %((time.time() - start_time)))
			print(filepath)
			
		return {'FINISHED'}

	def invoke(self, context, event):
		wm = context.window_manager

		if True:
			# File selector
			wm.fileselect_add(self) # will run self.execute()
			return {'RUNNING_MODAL'}
		elif True:
			# search the enum
			wm.invoke_search_popup(self)
			return {'RUNNING_MODAL'}
		elif False:
			# Redo popup
			return wm.invoke_props_popup(self, event) #
		elif False:
			return self.execute(context)


### REGISTER ###

def menu_func(self, context):
	self.layout.operator(Export_objc.bl_idname, text="model file (.model)")

def register():
	bpy.utils.register_module(__name__)

	bpy.types.INFO_MT_file_export.append(menu_func)

def unregister():
	bpy.utils.unregister_module(__name__)

	bpy.types.INFO_MT_file_export.remove(menu_func)

if __name__ == "__main__":
	register()

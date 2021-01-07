import bpy
import ifcopenshell.util.schema
import blenderbim.bim.module.aggregate.assign_object as assign_object
from blenderbim.bim.ifc import IfcStore
from blenderbim.bim.module.aggregate.data import Data


class AssignObject(bpy.types.Operator):
    bl_idname = "bim.assign_object"
    bl_label = "Assign Object"
    relating_object: bpy.props.StringProperty()
    related_object: bpy.props.StringProperty()

    def execute(self, context):
        self.file = IfcStore.get_file()
        related_object = bpy.data.objects.get(self.related_object) if self.related_object else bpy.context.active_object
        props = related_object.BIMObjectProperties
        relating_object = bpy.data.objects.get(self.relating_object) if self.relating_object else props.relating_object
        if not relating_object or not relating_object.BIMObjectProperties.ifc_definition_id:
            return {"FINISHED"}
        product = self.file.by_id(props.ifc_definition_id)
        assign_object.Usecase(
            self.file,
            {
                "product": product,
                "relating_object": self.file.by_id(relating_object.BIMObjectProperties.ifc_definition_id),
            },
        ).execute()
        Data.load(props.ifc_definition_id)
        bpy.ops.bim.disable_editing_aggregate(obj=related_object.name)

        declaration = IfcStore.get_schema().declaration_by_name(product.is_a())
        # TODO: we may not need this conditional if aggregates stop using collection instances
        if ifcopenshell.util.schema.is_a(declaration, "IfcSpatialElement"):
            related_collection = related_object.users_collection[0]
            relating_collection = relating_object.users_collection[0]
            self.remove_collection(bpy.context.scene.collection, related_collection)
            for collection in bpy.data.collections:
                if collection == relating_collection:
                    collection.children.link(related_collection)
                    continue
                self.remove_collection(collection, related_collection)
        return {"FINISHED"}

    def remove_collection(self, parent, child):
        try:
            parent.children.unlink(child)
        except:
            pass


class EnableEditingAggregate(bpy.types.Operator):
    bl_idname = "bim.enable_editing_aggregate"
    bl_label = "Enable Editing Aggregate"

    def execute(self, context):
        bpy.context.active_object.BIMObjectProperties.relating_object = None
        bpy.context.active_object.BIMObjectProperties.is_editing_aggregate = True
        return {"FINISHED"}


class DisableEditingAggregate(bpy.types.Operator):
    bl_idname = "bim.disable_editing_aggregate"
    bl_label = "Disable Editing Aggregate"
    obj: bpy.props.StringProperty()

    def execute(self, context):
        obj = bpy.data.objects.get(self.obj) if self.obj else bpy.context.active_object
        obj.BIMObjectProperties.is_editing_aggregate = False
        return {"FINISHED"}
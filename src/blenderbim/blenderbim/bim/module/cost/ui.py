from bpy.types import Panel, UIList
from blenderbim.bim.ifc import IfcStore
from ifcopenshell.api.cost.data import Data


class BIM_PT_cost_schedules(Panel):
    bl_label = "IFC Cost Schedules"
    bl_idname = "BIM_PT_cost_schedules"
    bl_options = {"DEFAULT_CLOSED"}
    bl_space_type = "PROPERTIES"
    bl_region_type = "WINDOW"
    bl_context = "scene"

    @classmethod
    def poll(cls, context):
        return IfcStore.get_file()

    def draw(self, context):
        self.props = context.scene.BIMCostProperties

        if not Data.is_loaded:
            Data.load(IfcStore.get_file())

        row = self.layout.row()
        row.operator("bim.add_cost_schedule", icon="ADD")

        for cost_schedule_id, cost_schedule in Data.cost_schedules.items():
            self.draw_cost_schedule_ui(cost_schedule_id, cost_schedule)

    def draw_cost_schedule_ui(self, cost_schedule_id, cost_schedule):
        row = self.layout.row(align=True)
        row.label(text=cost_schedule["Name"] or "Unnamed", icon="LINENUMBERS_ON")

        if self.props.active_cost_schedule_id and self.props.active_cost_schedule_id == cost_schedule_id:
            if self.props.is_editing == "COST_SCHEDULE":
                row.operator("bim.edit_cost_schedule", text="", icon="CHECKMARK")
            elif self.props.is_editing == "COST_ITEMS":
                row.operator("bim.add_summary_cost_item", text="", icon="ADD").cost_schedule = cost_schedule_id
            row.operator("bim.disable_editing_cost_schedule", text="", icon="CANCEL")
        elif self.props.active_cost_schedule_id:
            row.operator("bim.remove_cost_schedule", text="", icon="X").cost_schedule = cost_schedule_id
        else:
            row.operator("bim.enable_editing_cost_items", text="", icon="OUTLINER").cost_schedule = cost_schedule_id
            row.operator(
                "bim.enable_editing_cost_schedule", text="", icon="GREASEPENCIL"
            ).cost_schedule = cost_schedule_id
            row.operator("bim.remove_cost_schedule", text="", icon="X").cost_schedule = cost_schedule_id

        if self.props.active_cost_schedule_id == cost_schedule_id:
            if self.props.is_editing == "COST_SCHEDULE":
                self.draw_editable_cost_schedule_ui()
            elif self.props.is_editing == "COST_ITEMS":
                self.draw_editable_cost_item_ui(cost_schedule_id)

    def draw_editable_cost_schedule_ui(self):
        for attribute in self.props.cost_schedule_attributes:
            row = self.layout.row(align=True)
            if attribute.data_type == "string":
                row.prop(attribute, "string_value", text=attribute.name)
            elif attribute.data_type == "enum":
                row.prop(attribute, "enum_value", text=attribute.name)
            if attribute.is_optional:
                row.prop(attribute, "is_null", icon="RADIOBUT_OFF" if attribute.is_null else "RADIOBUT_ON", text="")

    def draw_editable_cost_item_ui(self, cost_schedule_id):
        self.layout.template_list(
            "BIM_UL_cost_items",
            "",
            self.props,
            "cost_items",
            self.props,
            "active_cost_item_index",
        )
        if self.props.active_cost_item_id:
            self.draw_editable_cost_item_attributes_ui()

    def draw_editable_cost_item_attributes_ui(self):
        for attribute in self.props.cost_item_attributes:
            row = self.layout.row(align=True)
            if attribute.data_type == "string":
                row.prop(attribute, "string_value", text=attribute.name)
            elif attribute.data_type == "boolean":
                row.prop(attribute, "bool_value", text=attribute.name)
            elif attribute.data_type == "integer":
                row.prop(attribute, "int_value", text=attribute.name)
            elif attribute.data_type == "enum":
                row.prop(attribute, "enum_value", text=attribute.name)
            if attribute.is_optional:
                row.prop(attribute, "is_null", icon="RADIOBUT_OFF" if attribute.is_null else "RADIOBUT_ON", text="")


class BIM_UL_cost_items(UIList):
    def draw_item(self, context, layout, data, item, icon, active_data, active_propname):
        if item:
            props = context.scene.BIMCostProperties
            row = layout.row(align=True)
            for i in range(0, item.level_index):
                row.label(text="", icon="BLANK1")
            if item.has_children:
                if item.is_expanded:
                    row.operator(
                        "bim.contract_cost_item", text="", emboss=False, icon="DISCLOSURE_TRI_DOWN"
                    ).cost_item = item.ifc_definition_id
                else:
                    row.operator(
                        "bim.expand_cost_item", text="", emboss=False, icon="DISCLOSURE_TRI_RIGHT"
                    ).cost_item = item.ifc_definition_id
            else:
                row.label(text="", icon="DOT")
            row.prop(item, "name", emboss=False, text="")

            if context.active_object:
                oprops = context.active_object.BIMObjectProperties
                row = layout.row(align=True)
                if oprops.ifc_definition_id in Data.cost_items[item.ifc_definition_id]["Controls"]:
                    op = row.operator("bim.unassign_control", text="", icon="KEYFRAME_HLT", emboss=False)
                    op.cost_item = item.ifc_definition_id
                else:
                    op = row.operator("bim.assign_control", text="", icon="KEYFRAME", emboss=False)
                    op.cost_item = item.ifc_definition_id

            if props.active_cost_item_id == item.ifc_definition_id:
                row.operator("bim.edit_cost_item", text="", icon="CHECKMARK")
                row.operator("bim.disable_editing_cost_item", text="", icon="CANCEL")
            elif props.active_cost_item_id:
                row.operator("bim.add_cost_item", text="", icon="ADD").cost_item = item.ifc_definition_id
                row.operator("bim.remove_cost_item", text="", icon="X").cost_item = item.ifc_definition_id
            else:
                row.operator(
                    "bim.enable_editing_cost_item", text="", icon="GREASEPENCIL"
                ).cost_item = item.ifc_definition_id
                row.operator("bim.add_cost_item", text="", icon="ADD").cost_item = item.ifc_definition_id
                row.operator("bim.remove_cost_item", text="", icon="X").cost_item = item.ifc_definition_id

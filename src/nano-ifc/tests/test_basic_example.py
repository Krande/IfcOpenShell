import nanoifc


def test_run_this():
    nanoifc.do_this()


def test_get_tessellated_boxes():
    box_meshes = nanoifc.get_tessellated_boxes([(0, 0, 0)], [(1, 1, 1)])
    assert len(box_meshes) == 1
    box_mesh = box_meshes[0]
    assert hasattr(box_mesh, "positions")
    assert hasattr(box_mesh, "indices")

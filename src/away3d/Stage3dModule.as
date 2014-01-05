package away3d
{
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.module.IModule;
    
    /**
     * 3d场景模块
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class Stage3dModule implements IModule
    {
        public function Stage3dModule()
        {
            ManagerHub.getInstance().register(ManagerGlobalName.Scene3dManager
                , new Away3dOrthScene());
        }
        
        public function get name():String
        {
            return "Stage3dModule";
        }
    }
}
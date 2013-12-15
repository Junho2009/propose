package sound
{
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.module.IModule;
    
    /**
     * 声音模块
     * @author junho
     * <br/>Create: 2013.12.15
     */    
    public class SoundModule implements IModule
    {
        public function SoundModule()
        {
            ManagerHub.getInstance().register(ManagerGlobalName.SoundManager
                , new SoundManager());
        }
        
        public function get name():String
        {
            return "";
        }
    }
}
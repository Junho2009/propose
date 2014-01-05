package sound
{
    import commons.load.FilePath;
    import commons.manager.ISoundManager;
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
            
            var soundMgr:ISoundManager = ManagerHub.getInstance().getManager(ManagerGlobalName.SoundManager) as ISoundManager;
            soundMgr.play(FilePath.root+"music/1.mp3", true);
        }
        
        public function get name():String
        {
            return "SoundModule";
        }
    }
}
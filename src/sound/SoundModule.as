package sound
{
    import mx.utils.StringUtil;
    
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
            
            var urlList:Vector.<String> = new Vector.<String>();
            const musicCount:uint = 3;
            for (var i:int = 0; i < musicCount; ++i)
            {
                urlList.push(StringUtil.substitute("{0}{1}.mp3", FilePath.musicPath, i+1));
            }
            
            soundMgr.playList(urlList, 5000, true);
        }
        
        public function get name():String
        {
            return "SoundModule";
        }
    }
}
package commons.manager
{
    import commons.manager.base.IManager;
    
    /**
     * 声音管理器
     * @author junho
     * <br/>Create: 2013.12.15
     */    
    public interface ISoundManager extends IManager
    {
        /**
         * 播放声音文件列表
         * @param urlList:Vector.&ltString&gt
         * @param delay:uint 两个声音文件之间的延迟播放时间（秒）
         * @param isLoop：Boolean 是否循环播放整个列表
         * 
         */        
        function playList(urlList:Vector.<String>, delay:uint = 0, isLoop:Boolean = false):void;
    }
}
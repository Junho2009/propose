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
        function play(url:String, isLoop:Boolean):void;
    }
}
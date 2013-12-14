package commons.load
{
    import commons.manager.base.IManager;

    /**
     * 加载管理器接口
     * @author junho
     * <br/>Create: 2013.12.15
     */    
    public interface ILoadManager extends IManager
    {
        function isLoading(url:String):Boolean;
        
        function load(url:String, info:LoadRequestInfo):void;
        
        function stopLoad(token:String):void;
        
        function isLoadingList(urlList:Array):void;
        
        function loadList(urlList:Array, info:LoadRequestInfo):void;
        
        function stopLoadList(token:String):void;
    }
}
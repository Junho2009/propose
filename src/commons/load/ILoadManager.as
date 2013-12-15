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
        
        function load(reqInfo:LoadRequestInfo):void;
        
        function stopLoad(token:String):void;
        
        function isLoadingList(reqInfo:LoadRequestInfo):Boolean;
        
        function loadList(reqInfo:LoadRequestInfo):void;
        
        function stopLoadList(token:String):void;
    }
}
package commons.manager
{
    import commons.manager.base.IManager;
    
    /**
     * 缓存管理器
     * @author junho
     * <br/>Create: 2013.12.21
     */    
    public interface ICacheManager extends IManager
    {
        function addData(data:*, key:String, version:String = null):void;
        
        function getData(key:String, version:String = null):*;
        
        function remove(key:String, version:String = null):void;
    }
}
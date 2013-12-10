package commons.manager
{
    import flash.display.DisplayObject;
    
    import commons.manager.base.IManager;
    
    /**
     * 窗体管理器
     * @author junho
     * <br/>Create: 2013.12.08
     */    
    public interface IWindowManager extends IManager
    {
        function register(name:String, window:Class):void;
        
        function unregister(name:String):void;
        
        function open(name:String, params:Object = null):void;
        
        function close(name:String, params:Object = null):void;
        
        function closeByInstance(window:DisplayObject):void;
    }
}
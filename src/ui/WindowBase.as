package ui
{
    import flash.display.Stage;
    import flash.events.Event;
    
    import commons.GlobalContext;
    import commons.manager.IWindowManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    
    import webgame.ui.Window;
    
    /**
     * 窗体基类
     * @author junho
     * <br/>Create: 2013.12.10
     */    
    public class WindowBase extends Window implements IWindow
    {
        protected var _winMgr:IWindowManager;
        
        protected var _globalStage:Stage;
        
        
        public function WindowBase(name:String = "WindowBase", w:uint = 0, h:uint = 0)
        {
            super(name, w, h);
            
            _winMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.WindowManager) as IWindowManager;
            _globalStage = GlobalContext.getInstance().stage;
            
            addEventListener(Event.ADDED_TO_STAGE, onWindowOpened);
            addEventListener(Event.REMOVED_FROM_STAGE, onWindowClosed);
        }
        
        public function set params(value:Object):void
        {
        }
        
        
        
        protected function onWindowOpened(e:Event):void
        {
            //...
        }
        
        protected function onWindowClosed(e:Event):void
        {
            //...
        }
        
        protected function close():void
        {
            _winMgr.closeByInstance(this);
        }
    }
}
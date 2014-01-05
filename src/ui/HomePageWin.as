package ui
{
    import flash.events.Event;
    
    import commons.GlobalContext;
    import commons.WindowGlobalName;

    /**
     * 主页
     * @author junho
     * <br/>Create: 2013.12.08
     */    
    public class HomePageWin extends WindowBase
    {
        private var _blessWall:BlessWall;
        
        
        public function HomePageWin()
        {
            super("HomePageWin", 0, 0);
            
            _blessWall = new BlessWall();
        }
        
        override public function init():void
        {
            super.init();
            
            _blessWall.init();
            addChild(_blessWall);
        }
        
        
        
        override protected function onWindowOpened(e:Event):void
        {
            _blessWall.addEventListener(Event.RESIZE, onBlessWallResized);
            GlobalContext.getInstance().stage.addEventListener(Event.RESIZE, onStageResize);
            
            adjustPos();
            _winMgr.open(WindowGlobalName.BLESS_SEND);
        }
        
        override protected function onWindowClosed(e:Event):void
        {
            _blessWall.removeEventListener(Event.RESIZE, onBlessWallResized);
            GlobalContext.getInstance().stage.removeEventListener(Event.RESIZE, onStageResize);
        }
        
        
        
        override protected function onStageResize(e:Event):void
        {
            adjustPos();
        }
        
        private function onBlessWallResized(e:Event):void
        {
            adjustPos();
        }
        
        private function adjustPos():void
        {
            _blessWall.x = GlobalContext.getInstance().stage.stageWidth - _blessWall.width >> 1;
            _blessWall.y = -_blessWall.height;
        }
    }
}
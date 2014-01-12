package ui
{
    import flash.events.Event;
    
    import commons.GlobalContext;
    import commons.WindowGlobalName;
    
    import webgame.ui.GixButton;

    /**
     * 主页
     * @author junho
     * <br/>Create: 2013.12.08
     */    
    public class HomePageWin extends WindowBase
    {
        private var _blessWall:BlessWall;
        
        private var _thankfulBtn:GixButton;
        
        
        public function HomePageWin()
        {
            super("HomePageWin", 0, 0);
            
            _blessWall = new BlessWall();
            _thankfulBtn = new GixButton();
        }
        
        override public function init():void
        {
            super.init();
            
            _blessWall.init();
            addChild(_blessWall);
            
            _thankfulBtn.init();
            _thankfulBtn.bindSkin(CommonRes.getInstance().createButtonSkin(1));
            _thankfulBtn.width = 90;
            _thankfulBtn.height = 30;
            _thankfulBtn.label = "特别鸣谢";
            addChild(_thankfulBtn);
        }
        
        
        
        override protected function onWindowOpened(e:Event):void
        {
            _blessWall.addEventListener(Event.RESIZE, onBlessWallResized);
            _thankfulBtn.callback = onOpenThankfulWin;
            
            GlobalContext.getInstance().stage.addEventListener(Event.RESIZE, onStageResize);
            
            adjustPos();
            _winMgr.open(WindowGlobalName.BLESS_SEND);
        }
        
        override protected function onWindowClosed(e:Event):void
        {
            _blessWall.removeEventListener(Event.RESIZE, onBlessWallResized);
            _thankfulBtn.callback = null;
            
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
            
            _thankfulBtn.x = GlobalContext.getInstance().stage.stageWidth - _thankfulBtn.width - 20;
            _thankfulBtn.y = GlobalContext.getInstance().stage.stageHeight - _thankfulBtn.height >> 1;
        }
        
        private function onOpenThankfulWin():void
        {
            _winMgr.open(WindowGlobalName.THANKFUL, null, CommonRes.getInstance().getJObj("thankfulData"));
        }
    }
}
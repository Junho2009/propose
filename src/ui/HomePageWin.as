package ui
{
    import flash.display.Bitmap;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    
    import caurina.transitions.Tweener;
    
    import commons.GlobalContext;
    import commons.load.FilePath;
    import commons.load.ILoadManager;
    import commons.load.LoadRequestInfo;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;

    public class HomePageWin extends WindowBase
    {
        private var _loadMgr:ILoadManager;
        
        private var _bg:Bitmap;
        
        
        public function HomePageWin()
        {
            super("HomePageWin", 0, 0);
            
            _loadMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.LoadManager) as ILoadManager;
        }
        
        override public function init():void
        {
            super.init();
            
            var shape:Sprite = new Sprite();
            shape.graphics.beginFill(0);
            shape.graphics.drawRoundRect(0, 0, 100, 100, 3);
            shape.graphics.endFill();
            backgroundImage = shape;
            
            fullscreen = true;
            
            var reqInfo:LoadRequestInfo = new LoadRequestInfo();
            reqInfo.url = FilePath.adapt+"homepage_bg.jpg";
            reqInfo.completedCallback = onBGLoaded;
            _loadMgr.load(reqInfo);
        }
        
        
        
        override protected function onWindowOpened(e:Event):void
        {
            GlobalContext.getInstance().stage.addEventListener(Event.RESIZE, onStageResize);
        }
        
        override protected function onWindowClosed(e:Event):void
        {
            GlobalContext.getInstance().stage.removeEventListener(Event.RESIZE, onStageResize);
        }
        
        
        
        private function onBGLoaded(img:Bitmap):void
        {
            _bg = img;
            
            var params:Object = new Object();
            params.time = 3;
            params.alpha = 1;
            params.transition = "linear";
            
            _bg.alpha = 0;
            Tweener.addTween(_bg, params);
            
            adjustBG();
            addChild(_bg);
        }
        
        private function onStageResize():void
        {
            adjustBG();
        }
        
        private function adjustBG():void
        {
            _bg.x = GlobalContext.getInstance().stage.stageWidth - _bg.width >> 1;
            _bg.y = GlobalContext.getInstance().stage.stageHeight - _bg.height >> 1;
        }
    }
}
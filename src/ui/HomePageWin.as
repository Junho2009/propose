package ui
{
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    
    import caurina.transitions.Tweener;
    
    import commons.GlobalContext;
    import commons.WindowGlobalName;
    import commons.load.FilePath;
    import commons.load.LoadRequestInfo;
    import commons.manager.ILoadManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;

    /**
     * 主页
     * @author junho
     * <br/>Create: 2013.12.08
     */    
    public class HomePageWin extends WindowBase
    {
        private var _loadMgr:ILoadManager;
        
        private var _pic:Bitmap;
        
        private var _blessWall:BlessWall;
        
        
        public function HomePageWin()
        {
            super("HomePageWin", 0, 0);
            
            _loadMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.LoadManager) as ILoadManager;
            
            _pic = new Bitmap();
            addChild(_pic);
            
            _blessWall = new BlessWall();
            addChild(_blessWall);
        }
        
        override public function init():void
        {
            super.init();
            
            var shape:Sprite = new Sprite();
            shape.graphics.beginFill(0);
            shape.graphics.drawRect(0, 0, 1, 1);
            shape.graphics.endFill();
            backgroundImage = shape;
            
            fullscreen = true;
            
            _blessWall.init();
            
            var reqInfo:LoadRequestInfo = new LoadRequestInfo();
            reqInfo.url = FilePath.adapt+"homepage_bg.jpg";
            reqInfo.completedCallback = onPicLoaded;
//            _loadMgr.load(reqInfo);
        }
        
        
        
        override protected function onWindowOpened(e:Event):void
        {
            _blessWall.addEventListener(Event.RESIZE, onBlessWallResized);
            GlobalContext.getInstance().stage.addEventListener(Event.RESIZE, onStageResize);
            
            adjustPic();
            _winMgr.open(WindowGlobalName.BLESS_SEND);
        }
        
        override protected function onWindowClosed(e:Event):void
        {
            _blessWall.removeEventListener(Event.RESIZE, onBlessWallResized);
            GlobalContext.getInstance().stage.removeEventListener(Event.RESIZE, onStageResize);
        }
        
        
        
        private function onPicLoaded(img:Bitmap):void
        {
            _pic.bitmapData = img.bitmapData;
            
            var params:Object = new Object();
            params.time = 3;
            params.alpha = 1;
            params.transition = "linear";
            
            _pic.alpha = 0;
            Tweener.addTween(_pic, params);
            
            adjustPic();
        }
        
        override protected function onStageResize(e:Event):void
        {
            adjustPic();
        }
        
        private function onBlessWallResized(e:Event):void
        {
            adjustPic();
        }
        
        private function adjustPic():void
        {
            _pic.x = GlobalContext.getInstance().stage.stageWidth - _pic.width >> 1;
            _pic.y = GlobalContext.getInstance().stage.stageHeight - _pic.height >> 1;
            
            _blessWall.x = _pic.x + (_pic.width - _blessWall.width >> 1);
            _blessWall.y = _pic.y - _blessWall.height;
        }
    }
}
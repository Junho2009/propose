package ui
{
    import flash.display.Bitmap;
    import flash.display.Shape;
    
    import commons.load.FilePath;
    import commons.load.ILoadManager;
    import commons.load.LoadRequestInfo;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;

    public class HomePageWin extends WindowBase
    {
        [Embed(source = "../../../resources/homepage_bg.jpg")]
        private var bg:Class;
        
        private var _loadMgr:ILoadManager;
        
        
        public function HomePageWin()
        {
            super("HomePageWin", 0, 0);
            
            _loadMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.LoadManager) as ILoadManager;
        }
        
        override public function init():void
        {
            super.init();
            
//            backgroundImage = new bg() as Bitmap;
            
            var shape:Shape = new Shape();
            shape.graphics.beginFill(0);
            shape.graphics.drawRoundRect(0, 0, 100, 100, 30);
            shape.graphics.endFill();
            backgroundImage = shape;
            
            fullscreen = true;
            
            var loadReqInfo:LoadRequestInfo = new LoadRequestInfo();
            loadReqInfo.callback = function(img:Bitmap):void
            {
                backgroundImage = img;
            };
            _loadMgr.load(FilePath.root + "homepage_bg.jpg", loadReqInfo);
        }
    }
}
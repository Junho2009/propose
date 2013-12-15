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
            loadReqInfo.url = FilePath.root + "homepage_bg.jpg";
            loadReqInfo.callback = function(img:Bitmap):void
            {
                backgroundImage = img;
            };
            _loadMgr.load(loadReqInfo);
            
            testLoad();
        }
        
        private function testLoad():void
        {
            var urlList:Vector.<String> = new Vector.<String>();
            urlList.push(FilePath.root + "icon/31012.png");
            urlList.push(FilePath.root + "icon/31013.png");
            urlList.push(FilePath.root + "icon/31014.png");
            urlList.push(FilePath.root + "icon/31015.png");
            urlList.push(FilePath.root + "icon/31016.png");
            urlList.push(FilePath.root + "icon/31017.png");
            urlList.push(FilePath.root + "icon/31018.png");
            urlList.push(FilePath.root + "icon/31019.png");
            urlList.push(FilePath.root + "icon/31020.png");
            
            const urlListLen:uint = urlList.length;
            for (var i:int = 0; i < urlListLen; ++i)
            {
                var loadReqInfo:LoadRequestInfo = new LoadRequestInfo();
                loadReqInfo.url = urlList[i];
                loadReqInfo.callbackData = {x: (i%5)*40, y: uint(i/5)*40};
                loadReqInfo.callback = function(img:Bitmap, data:Object):void
                {
                    img.x = data.x;
                    img.y = data.y;
                    addChild(img);
                }
                _loadMgr.load(loadReqInfo);
            }
        }
    }
}
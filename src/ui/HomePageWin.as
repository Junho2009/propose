package ui
{
    import flash.display.Bitmap;
    import flash.display.Shape;
    
    import commons.debug.Debug;
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
            loadReqInfo.completedCallback = function(img:Bitmap):void
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
                loadReqInfo.completedCallbackData = {url: urlList[i], x: (i%5)*40, y: uint(i/5)*40};
                loadReqInfo.completedCallback = function(img:Bitmap, data:Object):void
                {
                    Debug.log("文件加载完毕：{0}", data.url);
                    img.x = data.x;
                    img.y = data.y;
                    addChild(img);
                }
                _loadMgr.load(loadReqInfo);
                
                if (i == 5 || i == 7)
                    _loadMgr.stopLoad(loadReqInfo.token);
            }
            
            var listReqInfo:LoadRequestInfo = new LoadRequestInfo();
            var urlList2:Vector.<String> = new Vector.<String>();
            urlList2.push(FilePath.root + "icon/31100.png");
            urlList2.push(FilePath.root + "icon/31101.png");
            urlList2.push(FilePath.root + "icon/31102.png");
            urlList2.push(FilePath.root + "icon/31103.png");
            urlList2.push(FilePath.root + "icon/31104.png");
            urlList2.push(FilePath.root + "icon/31105.png");
            urlList2.push(FilePath.root + "icon/31106.png");
            urlList2.push(FilePath.root + "icon/31107.png");
            urlList2.push(FilePath.root + "icon/31108.png");
            urlList2.push(FilePath.root + "icon/31109.png");
            listReqInfo.urlList = urlList2;
            listReqInfo.completedCallback = function():void
            {
                Debug.log("文件列表我都加载完毕了！");
            };
            listReqInfo.singleCompCallback = function(url:String, data:Object):void
            {
                Debug.log("单个文件加载完毕：{0}", url);
                
                if (++_count > 5)
                    _loadMgr.stopLoadList(listReqInfo.token);
            };
            _loadMgr.loadList(listReqInfo);
        }
        
        private var _count:uint = 0;
    }
}
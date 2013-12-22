package ui
{
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import caurina.transitions.Tweener;
    
    import commons.GlobalContext;
    import commons.load.FilePath;
    import commons.load.LoadRequestInfo;
    import commons.manager.ILoadManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    
    import webgame.ui.View;
    import webgame.ui.Widget;
    
    /**
     * 祝福墙
     * @author junho
     * <br/>Create: 2013.12.22
     */    
    internal class BlessWall extends View
    {
        private var _loadMgr:ILoadManager;
        
        private var _rope:Widget;
        private var _bRoleMouseDown:Boolean = false;
        private var _curPosY:Number = 0;
        private var _bPulledDown:Boolean = false;
        private var _bAutoPullDoing:Boolean = false;
        
        
        public function BlessWall()
        {
            super("BlessWall");
            
            _loadMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.LoadManager) as ILoadManager;
            
            _rope = new Widget("");
            _rope.buttonMode = true;
        }
        
        override public function init():void
        {
            super.init();
            
            _rope.init();
            _rope.backgroundImage = CommonRes.getInstance().getBitmap("blessWallRope");
            
            var reqInfo:LoadRequestInfo = new LoadRequestInfo();
            reqInfo.url = FilePath.adapt+"blesswall_bg.jpg";
            reqInfo.completedCallback = onBGLoaded;
            _loadMgr.load(reqInfo);
        }
        
        
        
        private function onBGLoaded(img:Bitmap):void
        {
            backgroundImage = img;
            backgroundImage.alpha = 0.7;
            
            _rope.x = img.width - 70;
            _rope.y = img.height;
            _rope.addEventListener(MouseEvent.CLICK, onRoleClick);
            _rope.addEventListener(MouseEvent.MOUSE_DOWN, onRopeMouseDown);
            addChild(_rope);
            
            GlobalContext.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            GlobalContext.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            
            dispatchEvent(new Event(Event.RESIZE));
        }
        
        private function onRoleClick(e:MouseEvent):void
        {
            if (_curPosY != e.stageY)
                return;
            _bPulledDown ? onZipUp() : onPullDown();
        }
        
        private function onRopeMouseDown(e:MouseEvent):void
        {
            _bRoleMouseDown = true;
            _curPosY = e.stageY;
        }
        
        private function onMouseMove(e:MouseEvent):void
        {
            if (!_bRoleMouseDown || _bAutoPullDoing)
                return;
            
            const deltaY:Number = e.stageY - _curPosY;
            this.y = Math.max(-height, Math.min(y+deltaY, 0));
            _curPosY = e.stageY;
        }
        
        private function onMouseUp(e:MouseEvent):void
        {
            if (!_bRoleMouseDown || _bAutoPullDoing)
                return;
            _bRoleMouseDown = false;
        }
        
        private function onPullDown():void
        {
            var params:Object = new Object();
            params.y = 0;
            params.time = 0.5;
            params.transition = "linear";
            params.onComplete = function():void
            {
                _bAutoPullDoing = false;
                _bPulledDown = true;
            };
            
            _bAutoPullDoing = true;
            Tweener.removeTweens(this);
            Tweener.addTween(this, params);
        }
        
        private function onZipUp():void
        {
            var params:Object = new Object();
            params.y = -height;
            params.time = 0.5;
            params.transition = "linear";
            params.onComplete = function():void
            {
                _bAutoPullDoing = false;
                _bPulledDown = false;
            };
            
            _bAutoPullDoing = true;
            Tweener.removeTweens(this);
            Tweener.addTween(this, params);
        }
    }
}
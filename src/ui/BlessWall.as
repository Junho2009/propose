package ui
{
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import caurina.transitions.Tweener;
    
    import commons.GlobalContext;
    import commons.MathUtil;
    import commons.buses.NetBus;
    import commons.load.FilePath;
    import commons.load.LoadRequestInfo;
    import commons.manager.ILoadManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.protos.ProtoInList;
    import commons.vo.BlessVO;
    
    import mud.protos.BlessProtoIn_BlessInfo;
    import mud.protos.BlessProtoIn_BlessList;
    import mud.protos.BlessProtoOut_ReqBlessInfo;
    import mud.protos.BlessProtoOut_ReqBlessList;
    
    import webgame.core.bus.UIBus;
    import webgame.ui.GixButton;
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
        
        private var _bBGReady:Boolean = false;
        
        private var _rope:Widget;
        private var _bRoleMouseDown:Boolean = false;
        private var _curPosY:Number = 0;
        private var _bPulledDown:Boolean = false;
        private var _bAutoPullDoing:Boolean = false;
        
        private var _blessContentLayer:View;
        private var _blessPaperList:Vector.<BlessPaper>;
        
        private var _changePageBtn:GixButton;
        private var _maxPage:uint = 0;
        private var _curShowPage:uint = 0;
        
        
        public function BlessWall()
        {
            super("BlessWall");
            
            _loadMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.LoadManager) as ILoadManager;
            
            _rope = new Widget("");
            _rope.buttonMode = true;
            
            _blessContentLayer = new View("");
            addChild(_blessContentLayer);
            
            _blessPaperList = new Vector.<BlessPaper>();
            
            _changePageBtn = new GixButton();
            
            visible = false;
            
            bindProtos();
            
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }
        
        override public function init():void
        {
            super.init();
            
            _rope.init();
            _rope.backgroundImage = CommonRes.getInstance().getBitmap("blessWallRope");
            
            _blessContentLayer.init();
            _blessContentLayer.addEventListener(MouseEvent.MOUSE_DOWN, onBlessContentLayerMouseDown);
            
            _changePageBtn.init();
            _changePageBtn.width = 120;
            _changePageBtn.height = 30;
            _changePageBtn.label = "看看其他祝福";
            
            var reqInfo:LoadRequestInfo = new LoadRequestInfo();
            reqInfo.url = FilePath.adapt+"blesswall_bg.jpg";
            reqInfo.completedCallback = onBGLoaded;
            _loadMgr.load(reqInfo);
        }
        
        
        
        private function bindProtos():void
        {
            ProtoInList.getInstance().bind(BlessProtoIn_BlessInfo.HEAD, BlessProtoIn_BlessInfo);
            ProtoInList.getInstance().bind(BlessProtoIn_BlessList.HEAD, BlessProtoIn_BlessList);
            
            NetBus.getInstance().addCallback(BlessProtoIn_BlessInfo.HEAD, onRecvBlessInfo);
            NetBus.getInstance().addCallback(BlessProtoIn_BlessList.HEAD, onRecvBlessList);
            
            var reqBlessInfoProto:BlessProtoOut_ReqBlessInfo = new BlessProtoOut_ReqBlessInfo();
            NetBus.getInstance().send(reqBlessInfoProto);
        }
        
        private function onAddedToStage(e:Event):void
        {
            UIBus.getInstance().addEventListener(BlessEvent.ReqAddSelfBlessToWall, onReqAddSelfBlessToWall);
        }
        
        private function onRemovedFromStage(e:Event):void
        {
            UIBus.getInstance().removeEventListener(BlessEvent.ReqAddSelfBlessToWall, onReqAddSelfBlessToWall);
        }
        
        private function onBGLoaded(img:Bitmap):void
        {
            _bBGReady = true;
            
            backgroundImage = img;
            backgroundImage.alpha = 0.7;
            
            _rope.x = img.width - 70;
            _rope.y = img.height;
            _rope.addEventListener(MouseEvent.CLICK, onRoleClick);
            _rope.addEventListener(MouseEvent.MOUSE_DOWN, onRopeMouseDown);
            addChild(_rope);
            
            _changePageBtn.x = img.width - _changePageBtn.width >> 1;
            _changePageBtn.y = img.height - _changePageBtn.height - 20;
            _changePageBtn.addEventListener(MouseEvent.CLICK, onChangePage);
            addChild(_changePageBtn);
            
            GlobalContext.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            GlobalContext.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            
            _blessContentLayer.resize(this.width, this.height);
            randomBlessPapersPos();
            
            dispatchEvent(new Event(Event.RESIZE));
            
            visible = true;
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
        
        private function onChangePage(e:MouseEvent):void
        {
            var reqPage:uint = _curShowPage + 1;
            if (reqPage > _maxPage)
                reqPage = 1;
            
            if (reqPage != _curShowPage && reqPage >= 1 && reqPage <= _maxPage)
            {
                var reqBlessListProto:BlessProtoOut_ReqBlessList = new BlessProtoOut_ReqBlessList();
                reqBlessListProto.page = _curShowPage;
                NetBus.getInstance().send(reqBlessListProto);
            }
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
        
        private function onPullDown(compCallback:Function = null, callbackParam:Object = null):void
        {
            var params:Object = new Object();
            params.y = 0;
            params.time = 0.5;
            params.transition = "linear";
            params.onComplete = function():void
            {
                _bAutoPullDoing = false;
                _bPulledDown = true;
                
                if (null != compCallback)
                {
                    if (null != callbackParam)
                        compCallback(callbackParam);
                    else
                        compCallback();
                }
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
        
        private function randomBlessPapersPos():void
        {
            const curBlessPapershowNum:uint = _blessContentLayer.numChildren;
            for (var i:int = 0; i < curBlessPapershowNum; ++i)
            {
                var blessPaper:BlessPaper = _blessContentLayer.getChildAt(i) as BlessPaper;
                const maxPosX:Number = width - blessPaper.width;
                const maxPosY:Number = height - blessPaper.height;
                blessPaper.x = MathUtil.randomInt(0, maxPosX);
                blessPaper.y = MathUtil.randomInt(0, maxPosY);
            }
        }
        
        private function getBlessPaperRandomPos():Point
        {
            var pos:Point = new Point();
            
            const maxPosX:Number = width - BlessPaper.DefaultW;
            const maxPosY:Number = height - BlessPaper.DefaultH;
            pos.x = MathUtil.randomInt(0, maxPosX);
            pos.y = MathUtil.randomInt(0, maxPosY);
            
            return pos;
        }
        
        private function clearBlessPaper():void
        {
            while (_blessContentLayer.numChildren > 0)
                _blessContentLayer.removeChildAt(0);
            _blessPaperList.length = 0;
        }
        
        private function onBlessContentLayerMouseDown(e:MouseEvent):void
        {
            var blessPaper:BlessPaper = e.target as BlessPaper;
            if (null == blessPaper)
                return;
            _blessContentLayer.setChildIndex(blessPaper, _blessContentLayer.numChildren-1);
        }
        
        
        
        
        
        private function onRecvBlessInfo(inc:BlessProtoIn_BlessInfo):void
        {
            _maxPage = inc.page;
            _curShowPage = MathUtil.randomInt(1, _maxPage);
            
            var reqBlessListProto:BlessProtoOut_ReqBlessList = new BlessProtoOut_ReqBlessList();
            reqBlessListProto.page = _curShowPage;
            NetBus.getInstance().send(reqBlessListProto);
        }
        
        private function onRecvBlessList(inc:BlessProtoIn_BlessList):void
        {
            clearBlessPaper();
            
            var blessVOList:Vector.<BlessVO> = inc.blessList;
            const blessVOListLen:uint = blessVOList.length;
            for (var i:int = 0; i < blessVOListLen; ++i)
            {
                var blessPaper:BlessPaper = null;
                
                if (i >= _blessPaperList.length)
                {
                    blessPaper = new BlessPaper();
                    _blessPaperList.push(blessPaper);
                }
                
                blessPaper = _blessPaperList[i];
                blessPaper.paperType = MathUtil.randomInt(1, 4);
                blessPaper.content = blessVOList[i];
                _blessContentLayer.addChild(blessPaper);
            }
            
            if (_bBGReady)
                randomBlessPapersPos();
        }
        
        private function onReqAddSelfBlessToWall(e:BlessEvent):void
        {
            if (!_bPulledDown)
            {
                mouseChildren = false;
                mouseEnabled = false;
                onPullDown(onHandleAddBless2WallReqAfterPullDown, e.param);
            }
            else
            {
                onHandleAddBless2WallReqAfterPullDown(e.param);
            }
        }
        
        private function onHandleAddBless2WallReqAfterPullDown(param:Object):void
        {
            var blessVO:BlessVO = param.blessVO as BlessVO;
            const paperType:uint = param.paperType as uint;
            
            var pos:Point = getBlessPaperRandomPos();
            var blessPaper:BlessPaper = new BlessPaper();
            blessPaper.paperType = paperType;
            blessPaper.content = blessVO;
            blessPaper.x = pos.x;
            blessPaper.y = pos.y;
            _blessPaperList.push(blessPaper);
            blessPaper.visible = false;
            _blessContentLayer.addChild(blessPaper);
            
            var handleCallback:Function = function():void
            {
                blessPaper.visible = true;
                mouseChildren = true;
                mouseEnabled = true;
                onZipUp();
            };
            
            var gPos:Point = _blessContentLayer.localToGlobal(pos);
            UIBus.getInstance().dispatchEvent(new BlessEvent(BlessEvent.AddSelfBlessToWall
                , {pos: gPos, callback: handleCallback}));
        }
    }
}
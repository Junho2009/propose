package ui
{
    import flash.events.Event;
    import flash.geom.Point;
    import flash.text.TextFieldAutoSize;
    
    import mx.utils.StringUtil;
    
    import caurina.transitions.Tweener;
    
    import commons.GlobalContext;
    import commons.MathUtil;
    import commons.buses.NetBus;
    import commons.manager.ITimerManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.vo.BlessVO;
    
    import mud.protos.BlessProtoOut_SendBless;
    
    import webgame.core.bus.UIBus;
    import webgame.ui.GixButton;
    import webgame.ui.GixText;
    
    /**
     * 写祝福的祝愿纸
     * @author junho
     * <br/>Create: 2013.12.08
     */    
    public class BlessSendWin extends WindowBase implements IWindow
    {
        private var _timeMgr:ITimerManager;
        
        private var _content:GixTipsInput;
        private var _authorNameLabel:GixText;
        private var _authorName:GixTipsInput;
        
        private var _sendBtn:GixButton;
        
        private var _paperType:uint = 0;
        
        
        public function BlessSendWin()
        {
            super("BlessSendWin");
            
            _timeMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.TimerManager) as ITimerManager;
            
            _content = new GixTipsInput();
            _authorNameLabel = new GixText();
            _authorName = new GixTipsInput();
            _sendBtn = new GixButton();
            
            init();
        }
        
        override public function init():void
        {
            super.init();
            
            _paperType = MathUtil.randomInt(1, 4);
            backgroundImage = CommonRes.getInstance().getBitmap(StringUtil.substitute("blessPaper{0}", _paperType));
            
            _content.init();
            _content.color = 0x000000;
            _content.multiline = true;
            _content.wordWrap = true;
            _content.leading = 7;
            _content.tips = "(这里填上您的祝福^^)";
            _content.x = 10;
            _content.y = 50;
            _content.width = width - _content.x*2;
            _content.height = 80;
            addChild(_content);
            
            _authorNameLabel.init();
            _authorNameLabel.color = 0x000000;
            _authorNameLabel.autoSize = TextFieldAutoSize.LEFT;
            _authorNameLabel.text = "名字：";
            _authorNameLabel.x = 10;
            _authorNameLabel.y = _content.y + _content.height + 10;
            addChild(_authorNameLabel);
            
            _authorName.init();
            _authorName.color = 0x000000;
            _authorName.tips = "(填上您的名字^_^)";
            _authorName.x = _authorNameLabel.x + _authorNameLabel.width;
            _authorName.y = _authorNameLabel.y-2;
            _authorName.width = width - _authorName.x - 5;
            _authorName.height = 26;
            addChild(_authorName);
            
            _sendBtn.init();
            _sendBtn.bindSkin(null);
            _sendBtn.width = 63;
            _sendBtn.height = 22;
            _sendBtn.color = 0xff0000;
            _sendBtn.label = "发祝福";
            _sendBtn.x = 51;
            _sendBtn.y = 3;
            addChild(_sendBtn);
        }
        
        
        
        override protected function onWindowOpened(e:Event):void
        {
            _sendBtn.callback = onSend;
            
            x = 20;
            y = GlobalContext.getInstance().stage.stageHeight - height >> 1;
            
            UIBus.getInstance().addEventListener(BlessEvent.AddSelfBlessToWall, onAddSelfBlessToWall);
        }
        
        override protected function onWindowClosed(e:Event):void
        {
            _sendBtn.callback = null;
            UIBus.getInstance().removeEventListener(BlessEvent.AddSelfBlessToWall, onAddSelfBlessToWall);
        }
        
        
        
        private function onSend():void
        {
            if ("" == _content.text)
                return;
            
            var cmd:BlessProtoOut_SendBless = new BlessProtoOut_SendBless();
            cmd.name = _authorName.text;
            cmd.msg = _content.text.replace(/\r/g, "\n");
            NetBus.getInstance().send(cmd);
            
//            fadeOut();
            onReady2Show();
        }
        
        private function onReady2Show():void
        {
            var params:Object = new Object();
            params.x = GlobalContext.getInstance().stage.stageWidth >> 1;
            params.y = GlobalContext.getInstance().stage.stageHeight - height - 100;
            params.time = 0.5;
            params.transition = "easeInOutCirc";
            params.onComplete = function():void
            {
                var blessData:Object = new Object();
                blessData["author_name"] = _authorName.text;
                blessData["msg"] = _content.text;
                blessData["time"] = (new Date()).getTime() / 1000;
                var blessVO:BlessVO = new BlessVO(blessData);
                
                UIBus.getInstance().dispatchEvent(new BlessEvent(BlessEvent.ReqAddSelfBlessToWall
                    , {blessVO: blessVO, paperType: _paperType}));
            };
            Tweener.addTween(this, params);
        }
        
        private function onAddSelfBlessToWall(e:BlessEvent):void
        {
            var targetPos:Point = e.param.pos as Point;
            var callback:Function = e.param.callback as Function;
            
            var params:Object = new Object();
            params.x = targetPos.x;
            params.y = targetPos.y;
            params.time = 1;
            params.transition = "easeInOutCirc";
            params.onComplete = function():void
            {
                callback();
                
                alpha = 0;
                _timeMgr.setTask(fadeIn, 1024, false);
            }
            Tweener.addTween(this, params);
        }
        
        
        
        private function fadeOut():void
        {
            var params:Object = new Object();
            params.x = GlobalContext.getInstance().stage.stageWidth >> 1;
            params.y = 0;
            params.scaleX = 0;
            params.scaleY = 0;
            params.alpha = 0;
            params.time = 0.5;
            params.transition = "linear";
            params.onComplete = onFadeIn;
            Tweener.addTween(this, params);
        }
        
        private function fadeIn():void
        {
            _paperType = MathUtil.randomInt(1, 4);
            backgroundImage = CommonRes.getInstance().getBitmap(StringUtil.substitute("blessPaper{0}", _paperType));
            
            _content.text = "";
            
            x = 20;
            y = GlobalContext.getInstance().stage.stageHeight - height >> 1;
            
            scaleX = 1;
            scaleY = 1;
            alpha = 0;
            
            var param:Object = new Object();
            param.alpha = 1;
            param.time = 0.5;
            param.transition = "linear";
            Tweener.addTween(this, param);
        }
        
        private function onFadeIn():void
        {
            _timeMgr.setTask(fadeIn, 1000, false);
        }
    }
}
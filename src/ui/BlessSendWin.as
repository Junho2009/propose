package ui
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextFieldAutoSize;
    
    import mx.utils.StringUtil;
    
    import caurina.transitions.Tweener;
    
    import commons.GlobalContext;
    import commons.MathUtil;
    import commons.buses.NetBus;
    import commons.manager.ITimerManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    
    import mud.protos.BlessProtoOut_SendBless;
    
    import webgame.ui.GixButton;
    import webgame.ui.GixInput;
    import webgame.ui.GixText;
    import webgame.ui.Widget;
    
    /**
     * 写祝福的祝愿纸
     * @author junho
     * <br/>Create: 2013.12.08
     */    
    public class BlessSendWin extends WindowBase implements IWindow
    {
        private var _timeMgr:ITimerManager;
        
        private var _content:GixInput;
        private var _authorNameLabel:GixText;
        private var _authorName:GixInput;
        
        private var _sendBtn:GixButton;
        private var _closeBtn:Widget;
        
        
        public function BlessSendWin()
        {
            super("BlessSendWin");
            
            _timeMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.TimerManager) as ITimerManager;
            
            _content = new GixInput();
            _authorNameLabel = new GixText();
            _authorName = new GixInput();
            _sendBtn = new GixButton();
            _closeBtn = new Widget("");
            
            init();
        }
        
        override public function init():void
        {
            super.init();
            
            const paperType:int = MathUtil.randomInt(1, 4);
            backgroundImage = CommonRes.getInstance().getBitmap(StringUtil.substitute("blessPaper{0}", paperType));
            
            _content.init();
            _content.color = 0x000000;
            _content.multiline = true;
            _content.wordWrap = true;
            _content.leading = 7;
            _content.x = 15;
            _content.y = 50;
            _content.width = width - _content.x*2;
            _content.height = 80;
            addChild(_content);
            
            _authorNameLabel = new GixText();
            _authorNameLabel.init();
            _authorNameLabel.color = 0x000000;
            _authorNameLabel.autoSize = TextFieldAutoSize.LEFT;
            _authorNameLabel.text = "名字：";
            _authorNameLabel.x = 20;
            _authorNameLabel.y = _content.y + _content.height + 10;
            addChild(_authorNameLabel);
            
            _authorName = new GixInput();
            _authorName.init();
            _authorName.color = 0x000000;
            _authorName.x = _authorNameLabel.x + _authorNameLabel.width;
            _authorName.y = _authorNameLabel.y;
            _authorName.width = width - _authorName.x - 5;
            _authorName.height = _authorNameLabel.height;
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
            
            _closeBtn.init();
            _closeBtn.backgroundImage = CommonRes.getInstance().getBitmap("blessPaperCloseBtn");
            _closeBtn.buttonMode = true;
            _closeBtn.x = width - _closeBtn.width - 15;
            _closeBtn.y = 18;
//            addChild(_closeBtn);
        }
        
        
        
        override protected function onWindowOpened(e:Event):void
        {
            _sendBtn.callback = onSend;
            _closeBtn.addEventListener(MouseEvent.CLICK, close);
            
            x = 20;
            y = GlobalContext.getInstance().stage.stageHeight - height >> 1;
        }
        
        override protected function onWindowClosed(e:Event):void
        {
            _sendBtn.callback = null;
            _closeBtn.removeEventListener(MouseEvent.CLICK, close);
        }
        
        
        
        private function onSend():void
        {
            if ("" == _content.text)
                return;
            
            var cmd:BlessProtoOut_SendBless = new BlessProtoOut_SendBless();
            cmd.name = _authorName.text;
            cmd.msg = _content.text;
            NetBus.getInstance().send(cmd);
            
            fadeOut();
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
            const paperType:int = MathUtil.randomInt(1, 4);
            backgroundImage = CommonRes.getInstance().getBitmap(StringUtil.substitute("blessPaper{0}", paperType));
            
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
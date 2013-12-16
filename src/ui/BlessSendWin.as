package ui
{
    import flash.events.Event;
    
    import mx.utils.StringUtil;
    
    import commons.GlobalContext;
    import commons.buses.NetBus;
    
    import mud.protos.BlessProtoOut;
    
    import webgame.ui.GixButton;
    import webgame.ui.GixInput;
    
    public class BlessSendWin extends WindowBase implements IWindow
    {
        private var _params:Object = null;
        
        private var _content:GixInput;
        private var _sendBtn:GixButton;
        
        
        public function BlessSendWin()
        {
            super("BlessSendWin", 260, 280);
            
            _content = new GixInput();
            _sendBtn = new GixButton();
            
            init();
        }
        
        override public function set params(value:Object):void
        {
        }
        
        override public function init():void
        {
            super.init();
            
            _content.init();
            _content.multiline = true;
            _content.wordWrap = true;
            _content.x = 15;
            _content.y = 15;
            _content.width = width - _content.x*2;
            _content.height = 200;
            addChild(_content);
            
            _sendBtn.init();
            _sendBtn.width = 60;
            _sendBtn.height = 25;
            _sendBtn.label = "发送";
            _sendBtn.x = width - _sendBtn.width >> 1;
            _sendBtn.y = height - _sendBtn.height - 15;
            addChild(_sendBtn);
        }
        
        
        
        override protected function onWindowOpened(e:Event):void
        {
            _sendBtn.callback = onSend;
            
            x = GlobalContext.getInstance().stage.stageWidth - width >> 1;
            y = GlobalContext.getInstance().stage.stageHeight - height >> 1;
        }
        
        override protected function onWindowClosed(e:Event):void
        {
            _sendBtn.callback = null;
        }
        
        private function onSend():void
        {
            if ("" == _content.text)
                return;
            
            var cmd:BlessProtoOut = new BlessProtoOut();
            cmd.name = StringUtil.substitute("friend{0}", Math.random());
            cmd.msg = _content.text;
            NetBus.getInstance().send(cmd);
            
            close();
        }
    }
}
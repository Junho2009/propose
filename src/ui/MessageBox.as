package ui
{
    import flash.display.Shape;
    import flash.events.Event;
    import flash.text.TextFormatAlign;
    
    import webgame.ui.GixButton;
    import webgame.ui.GixText;
    
    public class MessageBox extends WindowBase implements IWindow
    {
        private var _params:Object = null;
        
        private var _msg:GixText;
        private var _okBtn:GixButton;
        
        
        public function MessageBox()
        {
            super("MessageBox", 400, 160);
            
            _msg = new GixText();
            _okBtn = new GixButton();
            
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }
        
        override public function set params(value:Object):void
        {
            _params = value;
            
            if (_params is String)
                _msg.htmlText = String(_params);
        }
        
        override public function init():void
        {
            super.init();
            
            var bg:Shape = new Shape();
            bg.graphics.beginFill(0);
            bg.graphics.drawRoundRect(0, 0, width, height, 10);
            bg.graphics.endFill();
            backgroundImage = bg;
            
            _msg.init();
            _msg.align = TextFormatAlign.CENTER;
            _msg.multiline = true;
            _msg.wordWrap = true;
            _msg.x = 15;
            _msg.y = 15;
            _msg.width = width - _msg.x*2;
            _msg.height = 45;
            addChild(_msg);
            
            _okBtn.init();
            _okBtn.bindSkin(CommonRes.getInstance().createButtonSkin(1));
            _okBtn.width = 60;
            _okBtn.height = 25;
            _okBtn.label = "确定";
            _okBtn.x = width - _okBtn.width >> 1;
            _okBtn.y = height - _okBtn.height - 15;
            addChild(_okBtn);
        }
        
        private function onAddedToStage(e:Event):void
        {
            _okBtn.callback = close;
            
            x = _globalStage.stageWidth - width >> 1;
            y = _globalStage.stageHeight - height >> 1;
        }
        
        private function onRemovedFromStage(e:Event):void
        {
            _okBtn.callback = null;
        }
    }
}
package ui
{
    import flash.display.Shape;
    import flash.events.Event;
    import flash.text.TextFormatAlign;
    
    import commons.GlobalContext;
    import commons.WindowGlobalName;
    import commons.manager.IWindowManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    
    import webgame.ui.GixButton;
    import webgame.ui.GixText;
    import webgame.ui.Window;
    
    public class MessageBox extends Window implements IWindow
    {
        private var _winMgr:IWindowManager;
        private var _params:Object = null;
        
        private var _msg:GixText;
        private var _okBtn:GixButton;
        
        
        public function MessageBox()
        {
            super("MessageBox", 400, 160);
            
            _winMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.WindowManager) as IWindowManager;
            
            _msg = new GixText();
            _okBtn = new GixButton();
            
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
            
            init();
        }
        
        public function set params(value:Object):void
        {
            _params = value;
            
            if (_params is String)
                _msg.htmlText = String(_params);
        }
        
        override public function init():void
        {
            super.init();
            
            var bg:Shape = new Shape();
            bg.graphics.beginFill(0x868686);
            bg.graphics.drawRoundRect(0, 0, width, height, 20);
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
            _okBtn.width = 60;
            _okBtn.height = 25;
            _okBtn.label = "确定";
            _okBtn.x = width - _okBtn.width >> 1;
            _okBtn.y = height - _okBtn.height - 15;
            addChild(_okBtn);
        }
        
        private function onAddedToStage(e:Event):void
        {
            _okBtn.callback = onClose;
            
            x = GlobalContext.getInstance().stage.stageWidth - width >> 1;
            y = GlobalContext.getInstance().stage.stageHeight - height >> 1;
        }
        
        private function onRemovedFromStage(e:Event):void
        {
            _okBtn.callback = null;
        }
        
        private function onClose():void
        {
            _winMgr.close(WindowGlobalName.MSG_BOX);
        }
    }
}
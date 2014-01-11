package ui
{
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.text.TextFormatAlign;
    import flash.ui.Keyboard;
    
    import commons.GlobalContext;
    import commons.buses.NetBus;
    import commons.load.FilePath;
    import commons.load.LoadRequestInfo;
    import commons.manager.ILoadManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    
    import mud.protos.LoginProtoOut_Login;
    
    import webgame.ui.GixButton;
    import webgame.ui.GixText;
    import webgame.ui.Widget;

    /**
     * 登录窗口
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class LoginWin extends WindowBase implements IWindow
    {
        private var _loadMgr:ILoadManager;
        
        private var _twoDCodeTips:GixText;
        private var _twoDCodeImg:Widget;
        
        private var _tips:GixText;
        private var _input:GixTipsInput;
        private var _okBtn:GixButton;
        
        
        public function LoginWin()
        {
            super("LoginWin", 240, 70);
            
            _loadMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.LoadManager) as ILoadManager;
            
            _twoDCodeTips = new GixText();
            _twoDCodeImg = new Widget("");
            _tips = new GixText();
            _input = new GixTipsInput();
            _okBtn = new GixButton();
        }
        
        override public function init():void
        {
            super.init();
            
            _tips.init();
            _tips.align = TextFormatAlign.CENTER;
            _tips.multiline = true;
            _tips.width = 240;
            _tips.height = 45;
            _tips.text = "请输入您的名字：\n(输入名字以使我们知道您是哪位朋友^^)";
            _tips.x = 0;
            addChild(_tips);
            
            _input.init();
            _input.backgroundImage = CommonRes.getInstance().getSprite("inputBG");
            _input.width = 200;
            _input.height = 25;
            _input.align = TextFormatAlign.CENTER;
            _input.size = 14;
            _input.color = 0xffffff;
            _input.tips = "(输入您的名字)";
            _input.y = _tips.y + _tips.height;
            addChild(_input);
            
            _okBtn.init();
            _okBtn.bindSkin(CommonRes.getInstance().createButtonSkin(1));
            _okBtn.label = "确定";
            _okBtn.width = 45;
            _okBtn.height = 25;
            _okBtn.x = _input.x + _input.width + 5;
            _okBtn.y = _input.y;
            addChild(_okBtn);
            
            _twoDCodeTips.init();
            _twoDCodeTips.align = TextFormatAlign.CENTER;
            _twoDCodeTips.width = 240;
            _twoDCodeTips.height = 50;
            _twoDCodeTips.size = 14;
            _twoDCodeTips.color = 0xffea00;
            _twoDCodeTips.text = "扫描下面的二维码，\n可以下载我们的结婚微相本哦！";
            
            _twoDCodeImg.init();
            var twoDCodeImgReq:LoadRequestInfo = new LoadRequestInfo();
            twoDCodeImgReq.url = FilePath.root + "twod_code.jpg";
            twoDCodeImgReq.completedCallback = function(img:Bitmap):void
            {
                _twoDCodeImg.backgroundImage = img;
                adjustCtrlsPos();
                
                addChild(_twoDCodeTips);
                addChild(_twoDCodeImg);
            };
            _loadMgr.load(twoDCodeImgReq);
        }
        
        override protected function onWindowOpened(e:Event):void
        {
            _input.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            _okBtn.callback = onLogin;
        }
        
        override protected function onWindowClosed(e:Event):void
        {
            _input.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            _okBtn.callback = null;
        }
        
        override protected function onStageResize(e:Event):void
        {
            x = GlobalContext.getInstance().stage.stageWidth - width >> 1;
            y = GlobalContext.getInstance().stage.stageHeight - height >> 1;
        }
        
        private function adjustCtrlsPos():void
        {
            _twoDCodeImg.x = width - _twoDCodeImg.width >> 1;
            _twoDCodeImg.y = -_twoDCodeImg.height;
            
            _twoDCodeTips.x = 0;
            _twoDCodeTips.y = _twoDCodeImg.y - _twoDCodeTips.height;
            
            _tips.x = 0;
            _tips.y = _twoDCodeImg.y + _twoDCodeImg.height + 30;
            
            _input.x = 0;
            _input.y = _tips.y + _tips.height;
            
            _okBtn.x = _input.x + _input.width + 5;
            _okBtn.y = _input.y;
        }
        
        private function onKeyDown(e:KeyboardEvent):void
        {
            if (Keyboard.ENTER == e.keyCode)
                onLogin();
        }
        
        private function onLogin():void
        {
            if ("" == _input.text)
                return;
            
            var cmd:LoginProtoOut_Login = new LoginProtoOut_Login();
            cmd.userName = _input.text;
            NetBus.getInstance().send(cmd);
        }
    }
}
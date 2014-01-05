package login
{
    import flash.geom.Point;
    
    import commons.WindowGlobalName;
    import commons.buses.InnerEventBus;
    import commons.buses.NetBus;
    import commons.manager.ILoginManager;
    import commons.manager.IWindowManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.protos.ProtoInList;
    
    import mud.protos.LoginProtoIn_Login;
    
    /**
     * 登录管理器
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class LoginManager implements ILoginManager
    {
        private var _bLogined:Boolean = false;
        private var _userName:String = "";
        private var _bFirstTime:Boolean = true;
        
        
        public function LoginManager()
        {
            ProtoInList.getInstance().bind(LoginProtoIn_Login.HEAD, LoginProtoIn_Login);
            NetBus.getInstance().addCallback(LoginProtoIn_Login.HEAD, onRecvLoginRes);
        }
        
        public function get isLogined():Boolean
        {
            return _bLogined;
        }
        
        public function get userName():String
        {
            return _userName;
        }
        
        private function onRecvLoginRes(inc:LoginProtoIn_Login):void
        {
            if (1 == inc.flag)
            {
                _userName = inc.userName;
                InnerEventBus.getInstance().dispatchEvent(new LoginEvent(LoginEvent.UserNameChanged));
                
                if (_bFirstTime)
                {
                    _bLogined = true;
                    
                    var wm:IWindowManager = ManagerHub.getInstance().getManager(ManagerGlobalName.WindowManager) as IWindowManager;
                    wm.close(WindowGlobalName.LOGIN_WIN);
                    wm.open(WindowGlobalName.HOME_PAGE, new Point(0, 0));
                    
                    InnerEventBus.getInstance().dispatchEvent(new LoginEvent(LoginEvent.LoginSuccessfully));
                    
                    _bFirstTime = false;
                }
            }
        }
    }
}
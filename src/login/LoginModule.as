package login
{
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.module.IModule;
    
    /**
     * 登录模块
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class LoginModule implements IModule
    {
        public function LoginModule()
        {
            ManagerHub.getInstance().register(ManagerGlobalName.LoginManager
                , new LoginManager());
        }
        
        public function get name():String
        {
            return "LoginModule";
        }
    }
}
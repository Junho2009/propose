package login
{
    import flash.events.Event;
    
    /**
     * 登录相关事件
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class LoginEvent extends Event
    {
        public static const LoginSuccessfully:String = "LoginEvent.LoginSuccessfully";
        
        public static const UserNameChanged:String = "LoginEvent.UserNameChanged";
        
        
        public function LoginEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}
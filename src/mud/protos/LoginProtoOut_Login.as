package mud.protos
{
    import mud.protos.base.MudProtoOut;
    
    /**
     * 登录输出协议-登录
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class LoginProtoOut_Login extends MudProtoOut
    {
        public var userName:String = "";
        
        
        public function LoginProtoOut_Login()
        {
            super("login", 10001);
        }
        
        override protected function readyPropList():void
        {
            _propList.push(userName);
        }
    }
}
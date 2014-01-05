package mud.protos
{
    import mud.protos.base.MudProtoIn;
    
    /**
     * 登录输入协议-登录
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class LoginProtoIn_Login extends MudProtoIn
    {
        public static const HEAD:String = "10001";
        
        
        private var _flag:int = 0;
        private var _userName:String = "";
        
        
        public function LoginProtoIn_Login()
        {
            super(HEAD);
        }
        
        public function get flag():int
        {
            return _flag;
        }
        
        public function get userName():String
        {
            return _userName;
        }
        
        override protected function analyseRawData(rawData:*):void
        {
            super.analyseRawData(rawData);
            
            _flag = readInt();
            _userName = readString();
        }
    }
}
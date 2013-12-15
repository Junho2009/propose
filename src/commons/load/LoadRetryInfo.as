package commons.load
{
    /**
     * 加载重试信息
     * @author junho
     * <br>Create: 2013.12.15
     */    
    public class LoadRetryInfo
    {
        public var retriedTimes:uint = 0; // 已重试次数
        public var readyTime:uint = 0; // 已等待重试的时间
        public var reqInfo:LoadRequestInfo = null; // 相关的加载请求信息
        
        public function LoadRetryInfo()
        {
        }
        
        public function dispose():void
        {
            reqInfo = null;
        }
    }
}
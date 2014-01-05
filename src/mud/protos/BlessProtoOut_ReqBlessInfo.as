package mud.protos
{
    import mud.protos.base.MudProtoOut;
    
    /**
     * 祝福输出协议-请求祝福数据信息
     * @author junho
     * <br/>Create: 2013.12.22
     */    
    public class BlessProtoOut_ReqBlessInfo extends MudProtoOut
    {
        public function BlessProtoOut_ReqBlessInfo()
        {
            super("bless", 131401);
        }
    }
}
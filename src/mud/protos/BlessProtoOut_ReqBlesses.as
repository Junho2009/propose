package mud.protos
{
    import mud.protos.base.MudProtoOut;
    
    /**
     * 请求祝福列表信息
     * @author junho
     * <br/>Create: 2013.12.22
     */    
    public class BlessProtoOut_ReqBlesses extends MudProtoOut
    {
        public var page:uint;
        
        
        public function BlessProtoOut_ReqBlesses()
        {
            super("bless", 131401);
        }
    }
}
package mud.protos
{
    import mud.protos.base.MudProtoOut;
    
    /**
     * 鲜花输出协议-送花限额信息
     * @author junho
     * <br/>Create: 2014.01.02
     */    
    public class FlowerProtoOut_SendLimInfo extends MudProtoOut
    {
        public function FlowerProtoOut_SendLimInfo()
        {
            super("flower", 111102);
        }
    }
}
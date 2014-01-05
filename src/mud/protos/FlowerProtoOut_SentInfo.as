package mud.protos
{
    import mud.protos.base.MudProtoOut;
    
    /**
     * 鲜花输出协议-已发送鲜花的信息
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class FlowerProtoOut_SentInfo extends MudProtoOut
    {
        public function FlowerProtoOut_SentInfo()
        {
            super("flower", 111101);
        }
    }
}
package mud.protos
{
    import mud.protos.base.MudProtoIn;
    
    /**
     * 鲜花输入协议-显示特效
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class FlowerProtoIn_ShowEffect extends MudProtoIn
    {
        public static const HEAD:String = "111199";
        
        
        public function FlowerProtoIn_ShowEffect()
        {
            super(HEAD);
        }
    }
}
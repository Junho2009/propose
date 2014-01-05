package mud.protos
{
    import mud.protos.base.MudProtoOut;
    
    /**
     * 鲜花输出协议-送花
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class FlowerProtoOut_SendFlower extends MudProtoOut
    {
        public var num:uint = 0;
        
        public function FlowerProtoOut_SendFlower()
        {
            super("flower", 111103);
        }
        
        override protected function readyPropList():void
        {
            _propList.push(num);
        }
    }
}
package commons.manager
{
    import flash.utils.ByteArray;
    
    import commons.manager.base.IManager;
    import commons.protos.ProtoInBase;

    /**
     * 输入协议的管理器
     * @author Junho
     * <br/>Create: 2013.11.30
     */
    public interface IProtoInManager extends IManager
    {
        /**
         * 将原始数据转换为输入协议对象列表（原始数据中可能含有多条协议的内容）
         * @param rawData:ByteArray
         * @return Vector.&ltProtoInBase&gt
         * 
         */
        function toProtoIn(rawData:ByteArray):Vector.<ProtoInBase>;
    }
}
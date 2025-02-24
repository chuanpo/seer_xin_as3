package org.taomee.tmf
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TmfByteArray extends ByteArray
   {
      public function TmfByteArray(data:IDataInput)
      {
         super();
         data.readBytes(this,bytesAvailable);
      }
   }
}


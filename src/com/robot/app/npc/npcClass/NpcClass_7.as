package com.robot.app.npc.npcClass
{
   import com.robot.core.mode.NpcModel;
   import com.robot.core.npc.INpc;
   import com.robot.core.npc.NpcInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import com.robot.core.npc.NPC;
   import com.robot.core.event.NpcEvent;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.npc.NpcDialog;
   import com.robot.app.task.control.TaskController_42;
   import com.robot.core.ui.alert.Alarm;
   import org.taomee.manager.EventManager;
   
   public class NpcClass_7 implements INpc
   {
      private var _curNpcModel:NpcModel;
      
      public function NpcClass_7(info:NpcInfo, mc:DisplayObject)
      {
         super();
         this._curNpcModel = new NpcModel(info,mc as Sprite);
         this._curNpcModel.addEventListener(NpcEvent.NPC_CLICK,this.onClickNpc);
      }
      
      public function destroy() : void
      {
         if(Boolean(this._curNpcModel))
         {
            this._curNpcModel.destroy();
            this._curNpcModel = null;
         }
      }
      private function onClickNpc(e:NpcEvent) : void
      {
         this._curNpcModel.refreshTask();
         if(e.taskID == 42)
         {
            TasksManager.getProStatusList(42,function(arr:Array):void{
               if(Boolean(arr[0]) && !arr[1]){
                  NpcTipDialog.show("你是谁？\r胆敢闯入精灵圣殿，快给我离开！",function():void{
                     NpcTipDialog.show("（如果我告诉长老我是来自未来的赛尔，是不是会随意改变历史呢？不行，我不能说）\r我只是一个星球旅行者，路过这里而已，我并没有恶意……",function():void{
                        NpcTipDialog.show("不管你有没有恶意都快点离开这里吧，这里不是你该来的地方……",function():void{
                           NpcTipDialog.show("这里究竟发生了什么？为什么我看不到其他赫尔卡星人呢？",function():void{
                              NpcTipDialog.show("失控的机械巨人和叛变的机械精灵已经完全失去控制了，还包围了我们的逃离飞船！\r我的赫尔卡星人民还等着我把他们救出来……",function():void{
                                 NpcTipDialog.show("我愿意帮你营救他们！",function():void{
                                    NpcTipDialog.showAnswer("不行!你是打不过那个机械巨人的！我想现在唯一的办法就是研究出比赫尔卡特精灵更厉害的机械精灵！\r你真的愿意为我们冒险吗？",function():void{
                                       NpcTipDialog.show("当然愿意！我们赛尔号有位全宇宙最厉害的精灵博士，他一定能帮我们研究出比赫尔卡特精灵更厉害的机械精灵！",function():void{
                                          NpcTipDialog.show("太好了！我这里有一只卡塔精灵，现在将他交付于你。相信他一定能派上用场！",function():void{
                                             NpcTipDialog.show("我这就返回赛尔号，寻找博士！",function():void{
                                                NpcTipDialog.show("（轰隆隆）\r什么声音？！",function():void{
                                                   NpcTipDialog.show("是机械巨人！赛尔，你在这里拖延时间！我去将卡塔精灵护送到博士那里！",function():void{
                                                      TasksManager.complete(TaskController_42.TASK_ID,1,function():void{
                                                         TaskController_42.showPanel();
                                                      })
                                                   },NpcTipDialog.NONO)
                                                },NpcTipDialog.SEER)
                                             },NpcTipDialog.SEER)
                                          },NpcTipDialog.ELDER)
                                       },NpcTipDialog.SEER)
                                    },null,NpcTipDialog.ELDER)
                                 },NpcTipDialog.SEER)
                              },NpcTipDialog.ELDER)
                           },NpcTipDialog.SEER)
                        },NpcTipDialog.ELDER)
                     },NpcTipDialog.SEER)
                  },NpcTipDialog.ELDER)
               }else if(Boolean(arr[1]) && !arr[2])
               {
                  NpcTipDialog.show("相信交付于你的卡塔精灵他一定能派上用场！",null,NpcTipDialog.ELDER)
               }else if(Boolean(arr[2]) && !arr[3])
               {
                  NpcTipDialog.show("相信交付于你的卡塔精灵他一定能派上用场！",null,NpcTipDialog.ELDER)
               }else if(Boolean(arr[3]) && !arr[4])
               {
                  NpcTipDialog.show("相信交付于你的卡塔精灵他一定能派上用场！",null,NpcTipDialog.ELDER)
               }else if(Boolean(arr[4]) && !arr[5])
               {
                  NpcTipDialog.show("天！太棒了！你为什么可以制造出这样完美的机械精灵？你究竟是谁？",null,NpcTipDialog.ELDER)
               }
            })
         }else
         {
            NpcDialog.show(NPC.ELDER,["我是赫尔卡星长老！"],['你知道"她"在哪里吗?',"哈哈..原来赫尔卡星长老是这个样子..."],
            [function():void{EventManager.dispatchEvent(new NpcEvent(NpcEvent.ORIGNAL_EVENT,_curNpcModel))},null])
         }
      }
      public function get npc() : NpcModel
      {
         return this._curNpcModel;
      }
   }
}


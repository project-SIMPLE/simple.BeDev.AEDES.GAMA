model GamaToUnityUDP_Multi_model_VR

import "AEDES-Map.gaml"

species unity_linker parent: abstract_unity_linker {
	//list<point> init_locations <- [{50.0, 50.0}];
	string player_species <- string(unity_player);
	int max_num_players  <- 4;
	int min_num_players  <- 1;
	
	
	
	unity_property up_map_agent;
	//unity_property up_default;


	list<point> init_locations <- define_init_locations();

	list<point> define_init_locations {
		return [{22.5,22.5,0.0},{22.5,22.5,0.0},{50.0,50.0,0.0},{50.0,50.0,0.0}];
	}
 
 
// list<point> init_locations <- [{22.5, 22.5}];


	init {
		do define_properties;
		//player_unity_properties <- [nil,nil,nil,nil];
		do add_background_geometries(map_agent,up_map_agent);
	}
	action define_properties {
		unity_aspect map_agent_aspect <- prefab_aspect("Prefabs/Visual Prefabs/City/Vehicles/Map",1.0,-1.0,1.0,0.0,precision);
		up_map_agent <- geometry_properties("map_agent","",map_agent_aspect,#no_interaction,false);
		unity_properties << up_map_agent;
	}
	
	reflex send_geometries {


		do add_geometries_to_send(map_agent,up_map_agent);
	}
	
	
	
	
	
	// ไม่ส่งข้อมูล world ไป Unity ทุก step (ช่วยลดโหลด)
	//bool do_send_world <- false;
	bool do_send_world <- true;
	
	// 🔁 ทำงานทุก 100 cycle และต้องมี player อยู่
//	reflex send_message when: every(100 #cycle) and not empty(unity_player){
//		
//		// แสดงข้อความใน console
//		//write "Send message: "  + cycle;
//		
//		// 📤 ส่ง message ไปยัง player ทุกคนใน Unity
//		// รูปแบบเป็น map: "ชื่อข้อมูล"::ค่า
//		do send_message players: unity_player as list mes: ["cycle":: cycle];
//	}


// 🔁 ทำงานทุก 100 cycle, ต้องมี player อยู่ และระบบต้องกด START แล้ว (start_simulation = true)
	reflex send_message when: every(1 #cycle) and not empty(unity_player) and start_simulation {
		
		// แสดงข้อความใน console เพื่อเอาไว้เช็คสถานะการทำงาน
		write "Sending Start status and Cycle: " + cycle;
		
		// 📤 ส่ง message ไปยัง player ทุกคนใน Unity
		// เพิ่มคู่ Key-Value -> "status"::"Start" เข้าไปใน Map เพื่อส่งบอก Unity
		do send_message players: unity_player as list mes: ["cycle":: cycle, "status":: "Start"];
	}











action receive_message (string id, string mes, string score_val, string name_val) {
    string clean_id <- lower_case(replace(id, " ", ""));
    
    // พยายามหาตัวที่ ID ตรงกันก่อน
    unity_player target_p <- first(unity_player where (lower_case(replace(each.name, " ", "")) = clean_id));
    
    // ถ้าหาไม่เจอ (เช่นในเคส Player_85 ของคุณ) ให้เลือกเอเจนท์ตัวแรกที่มีในระบบมาใช้แทน
    if (target_p = nil and not empty(unity_player)) {
        target_p <- first(unity_player);
    }
    
    if (target_p != nil) {
        ask target_p {
            self.last_update <- gama.machine_time;
            self.is_online <- true;
            
            // อัปเดตตำแหน่ง (ระบุพิกัด Z ให้ชัดเจนเพื่อให้ลอยเหนือพื้น)
//            self.location <- {x_val, y_val, 2.0}; 
            
            self.score <- int(score_val);
            self.display_name <- name_val;
            
          //  write "MATCHED: " + self.name + " moved to " + self.location;
        }
    }
}









}


species unity_player parent: abstract_unity_player{
	float player_size <- 1.0;
	rgb color <- #red;
	//float cone_distance <- 5.0 * player_size;
	float cone_distance <- 4.0;
	float cone_amplitude <- 90.0;
	float player_rotation <- 90.0;
	
//	bool to_display <- false;
bool to_display <- true;
	// --- ระบบเช็คสถานะการเชื่อมต่อ ---
    float last_update <- gama.machine_time; // เก็บเวลาที่ได้รับข้อมูลล่าสุด
    bool is_online <- true;
//	float z_offset <- 2.0;
	
	int score <- 0; // <--- เพิ่มบรรทัดนี้
	string ip <- ""; // <--- เพิ่มบรรทัดนี้เพื่อเก็บค่า IP ของผู้เล่นแต่ละคน
	string display_name <- ""; // <--- เพิ่มบรรทัดนี้เพื่อเก็บชื่อที่จะแสดงผล













	
	
//	aspect default {
//    // วาดวงกลมตามสถานะสี
//    draw circle(player_size/2.0) at: location + {0, 0, z_offset} color: color;
//    
//    // ✅ แก้ไขตรงนี้: ลบเครื่องหมาย : หลังคำว่า text
//    draw (display_name = "" ? name : display_name) at: location + {0, 0, z_offset + 1} size: 10 color: #black;
//}
	
	
	// Action นี้จะถูกเรียกอัตโนมัติเมื่อมี Player หลุดจาก Unity
 
	
	
	
	reflex debug_score {
        // ให้มันตะโกนบอกคะแนนตัวเองใน Console ทุกๆ step
         write name + " has score: " + score;
    }
    reflex check_connection {
        // ถ้าไม่มีข้อมูลส่งมาจาก Unity เกิน 3 วินาที (3000ms)
        if (gama.machine_time - last_update > 30000) {
            if (is_online) {
                is_online <- false;
                color <- #blue; // 🔵 เปลี่ยนเป็นสีฟ้าเมื่อหลุด
                write "🔌 [OFFLINE] " + name + " (Display: " + display_name + ") ข้อมูลขาดการติดต่อ";
            }
        }
    }

    reflex debug_score {
        // write name + " has score: " + score; // ปิดไว้ก่อนก็ได้ถ้ามันเยอะเกินไป
    }
}























experiment vr_xp parent:"Main" autorun: false type: unity {
    float minimum_cycle_duration <- 0.1;
    string unity_linker_species <- string(unity_linker);
    list<string> displays_to_hide <- ["test", "test"];
    float t_ref;

    action create_player(string id) {
        ask unity_linker { do create_player(id); }
    }

//    action remove_player(string id_input) {
//        if (not empty(unity_player)) {
//            ask first(unity_player where (each.name = id_input)) { do die; }
//        }
//    }

    output { 
        display test_VR parent: test {
            species unity_player;
            
            // ใช้คำสั่งดักจับเมาส์แบบดั้งเดิมที่เสถียรที่สุด
            event #mouse_down {
                float t <- gama.machine_time;
                if (t - t_ref) > 500 {
                    
                    // --- ลองใช้ #user_location แทน #event_location ---
                    point pos <- #user_location; 
                    
                    ask unity_linker {
                        move_player_event <- true;
                        write "GAMA: คลิกที่พิกัด " + pos + " ส่งสัญญาณไป Unity แล้ว";
                    }
                    t_ref <- t;
                }
            }
        }






display point_player1 parent: test {
    chart "Player Scores Comparison" type: histogram background: #white {
        // ใช้ each.name แทน medical_id กรณีที่ display_name ยังว่างอยู่
        datalist (unity_player collect (each.display_name = "" ? each.name : each.display_name)) 
                 value: (unity_player collect each.score) 
                 color: [#blue, #red, #green, #orange]; 
    }
}



	


        
    } 
}
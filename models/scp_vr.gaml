model GamaToUnityUDP_Multi_model_VR

import "scp.gaml"

species unity_linker parent: abstract_unity_linker {
	//list<point> init_locations <- [{50.0, 50.0}];
	string player_species <- string(unity_player);
	int max_num_players  <- 3;
	int min_num_players  <- 1;
	
	
	bool is_saved <- false;
	
	
	unity_property up_map_agent;
	//unity_property up_default;


	list<point> init_locations <- define_init_locations();

	list<point> define_init_locations {
		return [{78.7,-81.4,10.0},{78.7,-81.4,10.0},{78.7,-81.4,10.0}];
//		return [{78.7,-81.4,10.0}];
	}
 
 
// list<point> init_locations <- [{22.5, 22.5}];



string base_name <- "scp_data";
    string extension <- ".csv";
    string folder_path <- "../includes/SCP_CSV/";
    string final_file_name; 



//	init {
//		do define_properties;
//		//player_unity_properties <- [nil,nil,nil,nil];
//		do add_background_geometries(map_agent,up_map_agent);
//		
//		
//		int i <- 0;
//        string temp_name <- base_name + extension;
//        
//        // วนลูปตรวจสอบว่าไฟล์มีอยู่หรือไม่ ถ้ามีให้เพิ่มเลขต่อท้ายไปเรื่อยๆ
//        loop while: file_exists(folder_path + temp_name) {
//            i <- i + 1;
//            temp_name <- base_name + i + extension;
//            }
//            final_file_name <- temp_name;
//        write "บันทึกข้อมูลลงไฟล์: " + final_file_name;
//		
//		
//	}
	
	
	
	init {
        do define_properties;
        do add_background_geometries(map_agent, up_map_agent);
        
        int i <- 0;
        string temp_name <- base_name + extension;
        loop while: file_exists(folder_path + temp_name) {
            i <- i + 1;
            temp_name <- base_name + i + extension;
        }
        final_file_name <- temp_name;
        write "บันทึกข้อมูลลงไฟล์: " + final_file_name;
    }






	
	// 💾 ระบบตรวจสอบข้อมูลและบันทึกสถิติขยะรายบุคคล
//    reflex save_data {
//        if (not empty(unity_player)) {
//            
//            // ดึงข้อมูลผู้เล่นคนแรกมาตรวจสอบเงื่อนไข
//            unity_player target_p <- first(unity_player);
//            
//            // 🛑 เงื่อนไขการหยุด: ถ้าฝั่ง Unity ส่ง display_end_game มาเป็น 0 จะหยุดบันทึกทันที
//            if (target_p.display_end_game = 0) {
//                // ข้ามการบันทึก (หรือคุณสามารถเพิ่ม write บันทึกข้อความแจ้งเตือนตรงนี้ได้)
//            } 
//            // 🔄 หากไม่ใช่ 0 ให้บันทึกข้อมูลสถิติขยะและคะแนนทั้งหมดลงไฟล์ต่อ
//            else {
//                save [
////                    cycle, 
////                    time, 
//                    target_p.name, 
//                    target_p.display_name, 
//                    target_p.score,                // คะแนน
//                    target_p.red_in_blue,          // แดงในฟ้า
//                    target_p.red_in_green,         // แดงในเขียว
//                    target_p.red_in_yellow,        // แดงในเหลือง
//                    target_p.green_in_blue,        // เขียวในฟ้า
//                    target_p.green_in_red,         // เขียวในแดง
//                    target_p.green_in_yellow,      // เขียวในเหลือง
//                    target_p.blue_in_red,          // น้ำเงินในแดง
//                    target_p.blue_in_green,        // น้ำเงินในเขียว
//                    target_p.blue_in_yellow,       // น้ำเงินในเหลือง
//                    target_p.yellow_in_red,        // เหลืองในแดง
//                    target_p.yellow_in_green,      // เหลืองในเขียว
//                    target_p.yellow_in_blue        // เหลืองในฟ้า
//                ] 
//                to: folder_path + final_file_name 
//                rewrite: false 
//                header: true;
//            }
//        }
//    }







reflex save_data {
    if (not empty(unity_player)) {
        
        // ดึงข้อมูลผู้เล่นคนแรกมาตรวจสอบเงื่อนไข
        unity_player target_p <- first(unity_player);
        
        // 🛑 ตรวจสอบเงื่อนไข: ถ้า Unity ส่งสัญญาณจบเกมมาเป็น 0 และยังไม่เคยบันทึกไฟล์นี้มาก่อน
        if (target_p.display_end_game = 0 and not is_saved) {
            
            save [
                target_p.name, 
                target_p.display_name, 
                target_p.score,                // คะแนน
                target_p.red_in_blue,          // แดงในฟ้า
                target_p.red_in_green,         // แดงในเขียว
                target_p.red_in_yellow,        // แดงในเหลือง
                target_p.green_in_blue,        // เขียวในฟ้า
                target_p.green_in_red,         // เขียวในแดง
                target_p.green_in_yellow,      // เขียวในเหลือง
                target_p.blue_in_red,          // น้ำเงินในแดง
                target_p.blue_in_green,        // น้ำเงินในเขียว
                target_p.blue_in_yellow,       // น้ำเงินในเหลือง
                target_p.yellow_in_red,        // เหลืองในแดง
                target_p.yellow_in_green,      // เหลืองในเขียว
                target_p.yellow_in_blue        // เหลืองในฟ้า
            ] 
            to: folder_path + final_file_name 
            rewrite: false 
            header: true;
            
            // 🔒 ล็อคสถานะทันที เพื่อให้ใน 1 เกมบันทึกข้อมูลอันล่าสุดเพียงแถวเดียว ไม่บันทึกซ้ำซ้อน
            is_saved <- true;
            write "💾 [SUCCESS] บันทึกผลสถิติเกมชุดสุดท้ายลงไฟล์เรียบร้อยแล้ว: " + final_file_name;
        }
    }
}



	
	
	
	
	
	
	
	
//	reflex save_data {
//        save ["Cycle: " + cycle, "Time: " + time] to: folder_path + final_file_name rewrite: false header: true;
//    }
	
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
	reflex send_message when: every(1 #cycle) and not empty(unity_player) and start_simulation {
		
		// แสดงข้อความใน console
		//write "Send message: "  + cycle;
		
		// 📤 ส่ง message ไปยัง player ทุกคนใน Unity
		// รูปแบบเป็น map: "ชื่อข้อมูล"::ค่า
		do send_message players: unity_player as list mes: ["cycle":: cycle, "status":: "Start"];
	}
	















// ใน species unity_linker ส่วน action receive_message:
action receive_message (string id, string mes, string score_val, string name_val, 
    string rib, string rig, string riy, 
    string gib, string gir, string giy, 
    string bir, string big, string biy, 
    string yir, string yig, string yib,
    string end_game) {
    string clean_id <- lower_case(replace(id, " ", ""));
    unity_player target_p <- first(unity_player where (lower_case(replace(each.name, " ", "")) = clean_id));
    
    if (target_p != nil) {
        ask target_p {
            self.red_in_blue <- int(rib); self.red_in_green <- int(rig); self.red_in_yellow <- int(riy);
            self.green_in_blue <- int(gib); self.green_in_red <- int(gir); self.green_in_yellow <- int(giy);
            self.blue_in_red <- int(bir); self.blue_in_green <- int(big); self.blue_in_yellow <- int(biy);
            self.yellow_in_red <- int(yir); self.yellow_in_green <- int(yig); self.yellow_in_blue <- int(yib);
            self.score <- int(score_val);
            self.display_name <- name_val;
            self.display_end_game <- int(end_game);
         //    write "game is " + self.display_end_game;
        }
          
    }
}











}


species unity_player parent: abstract_unity_player{


// ขยะสีแดงที่ทิ้งผิด
    int red_in_blue <- 0; int red_in_green <- 0; int red_in_yellow <- 0;
    // ขยะสีเขียวที่ทิ้งผิด
    int green_in_blue <- 0; int green_in_red <- 0; int green_in_yellow <- 0;
    // ขยะสีน้ำเงินที่ทิ้งผิด
    int blue_in_red <- 0; int blue_in_green <- 0; int blue_in_yellow <- 0;
    // ขยะสีเหลืองที่ทิ้งผิด
    int yellow_in_red <- 0; int yellow_in_green <- 0; int yellow_in_blue <- 0;

//// ... ตัวแปรเดิมของคุณ ...
//    int bb_val <- 0; int gb_val <- 0; int rb_val <- 0; int yb_val <- 0;
//    int bw_val <- 0; int gw_val <- 0; int rw_val <- 0; int yw_val <- 0;



	
	float player_size <- 5.0;
	
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
	//string display_end_game <- -1;// กำหนดค่าเริ่มต้นเป็น -1 (หรือค่าอื่นที่ไม่ใช่ 0)
	int display_end_game <- -1;
//	aspect default {
//		if to_display {
//			if selected {
//				 draw circle(player_size) at: location + {0, 0, z_offset} color: rgb(#blue, 0.5);
//			}
//			draw circle(player_size/2.0) at: location + {0, 0, z_offset} color: color ;
//			draw player_perception_cone() color: rgb(color, 0.5);
//		}
//	}
	
	
	aspect default {
		if to_display {
			if selected {
				 draw circle(player_size) at: location + {0, 0, z_offset} color: rgb(#blue, 0.5);
			}
			draw circle(player_size/2.0) at: location + {0, 0, z_offset} color: color ;
			draw player_perception_cone() color: rgb(color, 0.5);
		}
	}
	
	
	// Action นี้จะถูกเรียกอัตโนมัติเมื่อมี Player หลุดจาก Unity
 
	
	
	
	reflex debug_score {
        // ให้มันตะโกนบอกคะแนนตัวเองใน Console ทุกๆ step
         write name + " has score: " + score;
    }
//    reflex check_connection {
//        // ถ้าไม่มีข้อมูลส่งมาจาก Unity เกิน 3 วินาที (3000ms)
//        if (gama.machine_time - last_update > 30000) {
//            if (is_online) {
//                is_online <- false;
//                color <- #blue; // 🔵 เปลี่ยนเป็นสีฟ้าเมื่อหลุด
//                write "🔌 [OFFLINE] " + name + " (Display: " + display_name + ") ข้อมูลขาดการติดต่อ";
//            }
//        }
//    }

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

    action remove_player(string id_input) {
        if (not empty(unity_player)) {
            ask first(unity_player where (each.name = id_input)) { do die; }
        }
    }

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

//        display point_player1 parent: test {
//            chart "Player Scores Comparison" type: histogram background: #white {
//                datalist (unity_player collect each.name) 
//                         value: (unity_player collect each.score) 
//                         color: [#blue, #red, #green, #orange]; 
//            }





display point_player1 type: 2d {
    chart "Player Scores Comparison" type: histogram background: #white {
        // ใช้ each.name แทน medical_id กรณีที่ display_name ยังว่างอยู่
        datalist (unity_player collect (each.display_name = "" ? each.name : each.display_name)) 
                 value: (unity_player collect each.score) 
                 color: [#blue, #red, #green, #orange]; 
    }
}


// สำหรับ Blue Bin Chart: แสดงขยะสีอื่น (Red, Green, Yellow) ที่ทิ้งผิดลงถังฟ้า
display "Blue Bin Chart" type: 2d {
    chart "Blue Bin: Wrong items" type: histogram series_label_position: onchart {
        data "Red Waste" value: unity_player collect each.red_in_blue color: #red;
        data "Green Waste" value: unity_player collect each.green_in_blue color: #green;
        data "Yellow Waste" value: unity_player collect each.yellow_in_blue color: #yellow;
    }
}
display "Green Bin Chart" type: 2d {
    chart "Green Bin: Wrong items" type: histogram series_label_position: onchart {
        data "Red Waste" value: unity_player collect each.red_in_green color: #red;
        data "Blue Waste" value: unity_player collect each.blue_in_green color: #blue;
        data "Yellow Waste" value: unity_player collect each.yellow_in_green color: #yellow;
    }
}
// ทำแบบเดียวกันกับ Red Bin และ Yellow Bin

display "Red Bin Chart" type: 2d {
    chart "Red Bin: Wrong items" type: histogram series_label_position: onchart {
        data "Blue Waste" value: unity_player collect each.blue_in_red color: #blue;
        data "Green Waste" value: unity_player collect each.green_in_red color: #green;
        data "Yellow Waste" value: unity_player collect each.yellow_in_red color: #yellow;
    }
}
display "Yellow Bin Chart" type: 2d {
    chart "yellow Bin: Wrong items" type: histogram series_label_position: onchart {
        data "Red Waste" value: unity_player collect each.red_in_yellow color: #red;
        data "Blue Waste" value: unity_player collect each.blue_in_yellow color: #blue;
        data "green Waste" value: unity_player collect each.green_in_yellow color: #green;
    }
}
// ทำแบบเดียวกันกับ Red Bin และ Yellow Bin



    } 
}

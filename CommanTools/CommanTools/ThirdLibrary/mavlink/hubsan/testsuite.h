/** @file
 *	@brief MAVLink comm protocol testsuite generated from hubsan.xml
 *	@see http://qgroundcontrol.org/mavlink/
 */
#ifndef HUBSAN_TESTSUITE_H
#define HUBSAN_TESTSUITE_H

#ifdef __cplusplus
extern "C" {
#endif

#ifndef MAVLINK_TEST_ALL
#define MAVLINK_TEST_ALL
static void mavlink_test_common(uint8_t, uint8_t, mavlink_message_t *last_msg);
static void mavlink_test_hubsan(uint8_t, uint8_t, mavlink_message_t *last_msg);

static void mavlink_test_all(uint8_t system_id, uint8_t component_id, mavlink_message_t *last_msg)
{
	mavlink_test_common(system_id, component_id, last_msg);
	mavlink_test_hubsan(system_id, component_id, last_msg);
}
#endif

#include "../common/testsuite.h"


static void mavlink_test_mission_del(uint8_t system_id, uint8_t component_id, mavlink_message_t *last_msg)
{
	mavlink_message_t msg;
        uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
        uint16_t i;
	mavlink_mission_del_t packet_in = {
		17235,139,206
    };
	mavlink_mission_del_t packet1, packet2;
        memset(&packet1, 0, sizeof(packet1));
        	packet1.seq = packet_in.seq;
        	packet1.target_system = packet_in.target_system;
        	packet1.target_component = packet_in.target_component;
        
        

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_mission_del_encode(system_id, component_id, &msg, &packet1);
	mavlink_msg_mission_del_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_mission_del_pack(system_id, component_id, &msg , packet1.target_system , packet1.target_component , packet1.seq );
	mavlink_msg_mission_del_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_mission_del_pack_chan(system_id, component_id, MAVLINK_COMM_0, &msg , packet1.target_system , packet1.target_component , packet1.seq );
	mavlink_msg_mission_del_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
        mavlink_msg_to_send_buffer(buffer, &msg);
        for (i=0; i<mavlink_msg_get_send_buffer_length(&msg); i++) {
        	comm_send_ch(MAVLINK_COMM_0, buffer[i]);
        }
	mavlink_msg_mission_del_decode(last_msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);
        
        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_mission_del_send(MAVLINK_COMM_1 , packet1.target_system , packet1.target_component , packet1.seq );
	mavlink_msg_mission_del_decode(last_msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);
}

static void mavlink_test_hubsan_ack(uint8_t system_id, uint8_t component_id, mavlink_message_t *last_msg)
{
	mavlink_message_t msg;
        uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
        uint16_t i;
	mavlink_hubsan_ack_t packet_in = {
		5,72,139,206,17,84,151
    };
	mavlink_hubsan_ack_t packet1, packet2;
        memset(&packet1, 0, sizeof(packet1));
        	packet1.target_system = packet_in.target_system;
        	packet1.target_component = packet_in.target_component;
        	packet1.msgid = packet_in.msgid;
        	packet1.param1 = packet_in.param1;
        	packet1.param2 = packet_in.param2;
        	packet1.param3 = packet_in.param3;
        	packet1.param4 = packet_in.param4;
        
        

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_ack_encode(system_id, component_id, &msg, &packet1);
	mavlink_msg_hubsan_ack_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_ack_pack(system_id, component_id, &msg , packet1.target_system , packet1.target_component , packet1.msgid , packet1.param1 , packet1.param2 , packet1.param3 , packet1.param4 );
	mavlink_msg_hubsan_ack_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_ack_pack_chan(system_id, component_id, MAVLINK_COMM_0, &msg , packet1.target_system , packet1.target_component , packet1.msgid , packet1.param1 , packet1.param2 , packet1.param3 , packet1.param4 );
	mavlink_msg_hubsan_ack_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
        mavlink_msg_to_send_buffer(buffer, &msg);
        for (i=0; i<mavlink_msg_get_send_buffer_length(&msg); i++) {
        	comm_send_ch(MAVLINK_COMM_0, buffer[i]);
        }
	mavlink_msg_hubsan_ack_decode(last_msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);
        
        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_ack_send(MAVLINK_COMM_1 , packet1.target_system , packet1.target_component , packet1.msgid , packet1.param1 , packet1.param2 , packet1.param3 , packet1.param4 );
	mavlink_msg_hubsan_ack_decode(last_msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);
}

static void mavlink_test_hubsan_quad_mode(uint8_t system_id, uint8_t component_id, mavlink_message_t *last_msg)
{
	mavlink_message_t msg;
        uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
        uint16_t i;
	mavlink_hubsan_quad_mode_t packet_in = {
		5,72,139
    };
	mavlink_hubsan_quad_mode_t packet1, packet2;
        memset(&packet1, 0, sizeof(packet1));
        	packet1.target_system = packet_in.target_system;
        	packet1.target_component = packet_in.target_component;
        	packet1.hubsan_quad_mode = packet_in.hubsan_quad_mode;
        
        

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_quad_mode_encode(system_id, component_id, &msg, &packet1);
	mavlink_msg_hubsan_quad_mode_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_quad_mode_pack(system_id, component_id, &msg , packet1.target_system , packet1.target_component , packet1.hubsan_quad_mode );
	mavlink_msg_hubsan_quad_mode_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_quad_mode_pack_chan(system_id, component_id, MAVLINK_COMM_0, &msg , packet1.target_system , packet1.target_component , packet1.hubsan_quad_mode );
	mavlink_msg_hubsan_quad_mode_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
        mavlink_msg_to_send_buffer(buffer, &msg);
        for (i=0; i<mavlink_msg_get_send_buffer_length(&msg); i++) {
        	comm_send_ch(MAVLINK_COMM_0, buffer[i]);
        }
	mavlink_msg_hubsan_quad_mode_decode(last_msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);
        
        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_quad_mode_send(MAVLINK_COMM_1 , packet1.target_system , packet1.target_component , packet1.hubsan_quad_mode );
	mavlink_msg_hubsan_quad_mode_decode(last_msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);
}

static void mavlink_test_hubsan_sd_request(uint8_t system_id, uint8_t component_id, mavlink_message_t *last_msg)
{
	mavlink_message_t msg;
        uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
        uint16_t i;
	mavlink_hubsan_sd_request_t packet_in = {
		5,72
    };
	mavlink_hubsan_sd_request_t packet1, packet2;
        memset(&packet1, 0, sizeof(packet1));
        	packet1.target_system = packet_in.target_system;
        	packet1.target_component = packet_in.target_component;
        
        

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_sd_request_encode(system_id, component_id, &msg, &packet1);
	mavlink_msg_hubsan_sd_request_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_sd_request_pack(system_id, component_id, &msg , packet1.target_system , packet1.target_component );
	mavlink_msg_hubsan_sd_request_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_sd_request_pack_chan(system_id, component_id, MAVLINK_COMM_0, &msg , packet1.target_system , packet1.target_component );
	mavlink_msg_hubsan_sd_request_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
        mavlink_msg_to_send_buffer(buffer, &msg);
        for (i=0; i<mavlink_msg_get_send_buffer_length(&msg); i++) {
        	comm_send_ch(MAVLINK_COMM_0, buffer[i]);
        }
	mavlink_msg_hubsan_sd_request_decode(last_msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);
        
        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_sd_request_send(MAVLINK_COMM_1 , packet1.target_system , packet1.target_component );
	mavlink_msg_hubsan_sd_request_decode(last_msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);
}

static void mavlink_test_hubsan_sd_status(uint8_t system_id, uint8_t component_id, mavlink_message_t *last_msg)
{
	mavlink_message_t msg;
        uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
        uint16_t i;
	mavlink_hubsan_sd_status_t packet_in = {
		17.0,45.0,29,96,163
    };
	mavlink_hubsan_sd_status_t packet1, packet2;
        memset(&packet1, 0, sizeof(packet1));
        	packet1.sd_capacity = packet_in.sd_capacity;
        	packet1.sd_surplus = packet_in.sd_surplus;
        	packet1.target_system = packet_in.target_system;
        	packet1.target_component = packet_in.target_component;
        	packet1.sd_status = packet_in.sd_status;
        
        

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_sd_status_encode(system_id, component_id, &msg, &packet1);
	mavlink_msg_hubsan_sd_status_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_sd_status_pack(system_id, component_id, &msg , packet1.target_system , packet1.target_component , packet1.sd_status , packet1.sd_capacity , packet1.sd_surplus );
	mavlink_msg_hubsan_sd_status_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_sd_status_pack_chan(system_id, component_id, MAVLINK_COMM_0, &msg , packet1.target_system , packet1.target_component , packet1.sd_status , packet1.sd_capacity , packet1.sd_surplus );
	mavlink_msg_hubsan_sd_status_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
        mavlink_msg_to_send_buffer(buffer, &msg);
        for (i=0; i<mavlink_msg_get_send_buffer_length(&msg); i++) {
        	comm_send_ch(MAVLINK_COMM_0, buffer[i]);
        }
	mavlink_msg_hubsan_sd_status_decode(last_msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);
        
        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_sd_status_send(MAVLINK_COMM_1 , packet1.target_system , packet1.target_component , packet1.sd_status , packet1.sd_capacity , packet1.sd_surplus );
	mavlink_msg_hubsan_sd_status_decode(last_msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);
}

static void mavlink_test_hubsan_quad_status(uint8_t system_id, uint8_t component_id, mavlink_message_t *last_msg)
{
	mavlink_message_t msg;
        uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
        uint16_t i;
	mavlink_hubsan_quad_status_t packet_in = {
		5,72,139,206
    };
	mavlink_hubsan_quad_status_t packet1, packet2;
        memset(&packet1, 0, sizeof(packet1));
        	packet1.target_system = packet_in.target_system;
        	packet1.target_component = packet_in.target_component;
        	packet1.recording_status = packet_in.recording_status;
        	packet1.quad_mode_status = packet_in.quad_mode_status;
        
        

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_quad_status_encode(system_id, component_id, &msg, &packet1);
	mavlink_msg_hubsan_quad_status_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_quad_status_pack(system_id, component_id, &msg , packet1.target_system , packet1.target_component , packet1.recording_status , packet1.quad_mode_status );
	mavlink_msg_hubsan_quad_status_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_quad_status_pack_chan(system_id, component_id, MAVLINK_COMM_0, &msg , packet1.target_system , packet1.target_component , packet1.recording_status , packet1.quad_mode_status );
	mavlink_msg_hubsan_quad_status_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
        mavlink_msg_to_send_buffer(buffer, &msg);
        for (i=0; i<mavlink_msg_get_send_buffer_length(&msg); i++) {
        	comm_send_ch(MAVLINK_COMM_0, buffer[i]);
        }
	mavlink_msg_hubsan_quad_status_decode(last_msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);
        
        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_quad_status_send(MAVLINK_COMM_1 , packet1.target_system , packet1.target_component , packet1.recording_status , packet1.quad_mode_status );
	mavlink_msg_hubsan_quad_status_decode(last_msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);
}

static void mavlink_test_hubsan_set_wifi(uint8_t system_id, uint8_t component_id, mavlink_message_t *last_msg)
{
	mavlink_message_t msg;
        uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
        uint16_t i;
	mavlink_hubsan_set_wifi_t packet_in = {
		5,72,"CDEFGHIJKLMNOPQRSTUVWXYZABCDE","GHIJKLMNOPQ"
    };
	mavlink_hubsan_set_wifi_t packet1, packet2;
        memset(&packet1, 0, sizeof(packet1));
        	packet1.target_system = packet_in.target_system;
        	packet1.target_component = packet_in.target_component;
        
        	mav_array_memcpy(packet1.wifi_ssid, packet_in.wifi_ssid, sizeof(char)*30);
        	mav_array_memcpy(packet1.wifi_key, packet_in.wifi_key, sizeof(char)*12);
        

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_set_wifi_encode(system_id, component_id, &msg, &packet1);
	mavlink_msg_hubsan_set_wifi_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_set_wifi_pack(system_id, component_id, &msg , packet1.target_system , packet1.target_component , packet1.wifi_ssid , packet1.wifi_key );
	mavlink_msg_hubsan_set_wifi_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_set_wifi_pack_chan(system_id, component_id, MAVLINK_COMM_0, &msg , packet1.target_system , packet1.target_component , packet1.wifi_ssid , packet1.wifi_key );
	mavlink_msg_hubsan_set_wifi_decode(&msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);

        memset(&packet2, 0, sizeof(packet2));
        mavlink_msg_to_send_buffer(buffer, &msg);
        for (i=0; i<mavlink_msg_get_send_buffer_length(&msg); i++) {
        	comm_send_ch(MAVLINK_COMM_0, buffer[i]);
        }
	mavlink_msg_hubsan_set_wifi_decode(last_msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);
        
        memset(&packet2, 0, sizeof(packet2));
	mavlink_msg_hubsan_set_wifi_send(MAVLINK_COMM_1 , packet1.target_system , packet1.target_component , packet1.wifi_ssid , packet1.wifi_key );
	mavlink_msg_hubsan_set_wifi_decode(last_msg, &packet2);
        MAVLINK_ASSERT(memcmp(&packet1, &packet2, sizeof(packet1)) == 0);
}

static void mavlink_test_hubsan(uint8_t system_id, uint8_t component_id, mavlink_message_t *last_msg)
{
	mavlink_test_mission_del(system_id, component_id, last_msg);
	mavlink_test_hubsan_ack(system_id, component_id, last_msg);
	mavlink_test_hubsan_quad_mode(system_id, component_id, last_msg);
	mavlink_test_hubsan_sd_request(system_id, component_id, last_msg);
	mavlink_test_hubsan_sd_status(system_id, component_id, last_msg);
	mavlink_test_hubsan_quad_status(system_id, component_id, last_msg);
	mavlink_test_hubsan_set_wifi(system_id, component_id, last_msg);
}

#ifdef __cplusplus
}
#endif // __cplusplus
#endif // HUBSAN_TESTSUITE_H

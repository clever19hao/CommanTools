// MESSAGE HUBSAN_SET_WIFI PACKING

#define MAVLINK_MSG_ID_HUBSAN_SET_WIFI 59

typedef struct __mavlink_hubsan_set_wifi_t
{
 uint8_t target_system; ///< System ID
 uint8_t target_component; ///< Component ID
 char wifi_ssid[30]; ///< wifi ssid
 char wifi_key[12]; ///< wifi key
} mavlink_hubsan_set_wifi_t;

#define MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN 44
#define MAVLINK_MSG_ID_59_LEN 44

#define MAVLINK_MSG_ID_HUBSAN_SET_WIFI_CRC 24
#define MAVLINK_MSG_ID_59_CRC 24

#define MAVLINK_MSG_HUBSAN_SET_WIFI_FIELD_WIFI_SSID_LEN 30
#define MAVLINK_MSG_HUBSAN_SET_WIFI_FIELD_WIFI_KEY_LEN 12

#define MAVLINK_MESSAGE_INFO_HUBSAN_SET_WIFI { \
	"HUBSAN_SET_WIFI", \
	4, \
	{  { "target_system", NULL, MAVLINK_TYPE_UINT8_T, 0, 0, offsetof(mavlink_hubsan_set_wifi_t, target_system) }, \
         { "target_component", NULL, MAVLINK_TYPE_UINT8_T, 0, 1, offsetof(mavlink_hubsan_set_wifi_t, target_component) }, \
         { "wifi_ssid", NULL, MAVLINK_TYPE_CHAR, 30, 2, offsetof(mavlink_hubsan_set_wifi_t, wifi_ssid) }, \
         { "wifi_key", NULL, MAVLINK_TYPE_CHAR, 12, 32, offsetof(mavlink_hubsan_set_wifi_t, wifi_key) }, \
         } \
}


/**
 * @brief Pack a hubsan_set_wifi message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 *
 * @param target_system System ID
 * @param target_component Component ID
 * @param wifi_ssid wifi ssid
 * @param wifi_key wifi key
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_hubsan_set_wifi_pack(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg,uint8_t target_system, uint8_t target_component, const char *wifi_ssid, const char *wifi_key)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN];
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_char_array(buf, 2, wifi_ssid, 30);
	_mav_put_char_array(buf, 32, wifi_key, 12);
        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN);
#else
	mavlink_hubsan_set_wifi_t packet;
	packet.target_system = target_system;
	packet.target_component = target_component;
	mav_array_memcpy(packet.wifi_ssid, wifi_ssid, sizeof(char)*30);
	mav_array_memcpy(packet.wifi_key, wifi_key, sizeof(char)*12);
        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN);
#endif

	msg->msgid = MAVLINK_MSG_ID_HUBSAN_SET_WIFI;
#if MAVLINK_CRC_EXTRA
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_CRC);
#else
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN);
#endif
}

/**
 * @brief Pack a hubsan_set_wifi message on a channel
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param target_system System ID
 * @param target_component Component ID
 * @param wifi_ssid wifi ssid
 * @param wifi_key wifi key
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_hubsan_set_wifi_pack_chan(uint8_t system_id, uint8_t component_id, uint8_t chan,
							   mavlink_message_t* msg,
						           uint8_t target_system,uint8_t target_component,const char *wifi_ssid,const char *wifi_key)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN];
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_char_array(buf, 2, wifi_ssid, 30);
	_mav_put_char_array(buf, 32, wifi_key, 12);
        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN);
#else
	mavlink_hubsan_set_wifi_t packet;
	packet.target_system = target_system;
	packet.target_component = target_component;
	mav_array_memcpy(packet.wifi_ssid, wifi_ssid, sizeof(char)*30);
	mav_array_memcpy(packet.wifi_key, wifi_key, sizeof(char)*12);
        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN);
#endif

	msg->msgid = MAVLINK_MSG_ID_HUBSAN_SET_WIFI;
#if MAVLINK_CRC_EXTRA
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_CRC);
#else
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN);
#endif
}

/**
 * @brief Encode a hubsan_set_wifi struct
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 * @param hubsan_set_wifi C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_hubsan_set_wifi_encode(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg, const mavlink_hubsan_set_wifi_t* hubsan_set_wifi)
{
	return mavlink_msg_hubsan_set_wifi_pack(system_id, component_id, msg, hubsan_set_wifi->target_system, hubsan_set_wifi->target_component, hubsan_set_wifi->wifi_ssid, hubsan_set_wifi->wifi_key);
}

/**
 * @brief Encode a hubsan_set_wifi struct on a channel
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param hubsan_set_wifi C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_hubsan_set_wifi_encode_chan(uint8_t system_id, uint8_t component_id, uint8_t chan, mavlink_message_t* msg, const mavlink_hubsan_set_wifi_t* hubsan_set_wifi)
{
	return mavlink_msg_hubsan_set_wifi_pack_chan(system_id, component_id, chan, msg, hubsan_set_wifi->target_system, hubsan_set_wifi->target_component, hubsan_set_wifi->wifi_ssid, hubsan_set_wifi->wifi_key);
}

/**
 * @brief Send a hubsan_set_wifi message
 * @param chan MAVLink channel to send the message
 *
 * @param target_system System ID
 * @param target_component Component ID
 * @param wifi_ssid wifi ssid
 * @param wifi_key wifi key
 */
#ifdef MAVLINK_USE_CONVENIENCE_FUNCTIONS

static inline void mavlink_msg_hubsan_set_wifi_send(mavlink_channel_t chan, uint8_t target_system, uint8_t target_component, const char *wifi_ssid, const char *wifi_key)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN];
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_char_array(buf, 2, wifi_ssid, 30);
	_mav_put_char_array(buf, 32, wifi_key, 12);
#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SET_WIFI, buf, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SET_WIFI, buf, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN);
#endif
#else
	mavlink_hubsan_set_wifi_t packet;
	packet.target_system = target_system;
	packet.target_component = target_component;
	mav_array_memcpy(packet.wifi_ssid, wifi_ssid, sizeof(char)*30);
	mav_array_memcpy(packet.wifi_key, wifi_key, sizeof(char)*12);
#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SET_WIFI, (const char *)&packet, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SET_WIFI, (const char *)&packet, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN);
#endif
#endif
}

#if MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN <= MAVLINK_MAX_PAYLOAD_LEN
/*
  This varient of _send() can be used to save stack space by re-using
  memory from the receive buffer.  The caller provides a
  mavlink_message_t which is the size of a full mavlink message. This
  is usually the receive buffer for the channel, and allows a reply to an
  incoming message with minimum stack space usage.
 */
static inline void mavlink_msg_hubsan_set_wifi_send_buf(mavlink_message_t *msgbuf, mavlink_channel_t chan,  uint8_t target_system, uint8_t target_component, const char *wifi_ssid, const char *wifi_key)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char *buf = (char *)msgbuf;
	_mav_put_uint8_t(buf, 0, target_system);
	_mav_put_uint8_t(buf, 1, target_component);
	_mav_put_char_array(buf, 2, wifi_ssid, 30);
	_mav_put_char_array(buf, 32, wifi_key, 12);
#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SET_WIFI, buf, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SET_WIFI, buf, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN);
#endif
#else
	mavlink_hubsan_set_wifi_t *packet = (mavlink_hubsan_set_wifi_t *)msgbuf;
	packet->target_system = target_system;
	packet->target_component = target_component;
	mav_array_memcpy(packet->wifi_ssid, wifi_ssid, sizeof(char)*30);
	mav_array_memcpy(packet->wifi_key, wifi_key, sizeof(char)*12);
#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SET_WIFI, (const char *)packet, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SET_WIFI, (const char *)packet, MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN);
#endif
#endif
}
#endif

#endif

// MESSAGE HUBSAN_SET_WIFI UNPACKING


/**
 * @brief Get field target_system from hubsan_set_wifi message
 *
 * @return System ID
 */
static inline uint8_t mavlink_msg_hubsan_set_wifi_get_target_system(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  0);
}

/**
 * @brief Get field target_component from hubsan_set_wifi message
 *
 * @return Component ID
 */
static inline uint8_t mavlink_msg_hubsan_set_wifi_get_target_component(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  1);
}

/**
 * @brief Get field wifi_ssid from hubsan_set_wifi message
 *
 * @return wifi ssid
 */
static inline uint16_t mavlink_msg_hubsan_set_wifi_get_wifi_ssid(const mavlink_message_t* msg, char *wifi_ssid)
{
	return _MAV_RETURN_char_array(msg, wifi_ssid, 30,  2);
}

/**
 * @brief Get field wifi_key from hubsan_set_wifi message
 *
 * @return wifi key
 */
static inline uint16_t mavlink_msg_hubsan_set_wifi_get_wifi_key(const mavlink_message_t* msg, char *wifi_key)
{
	return _MAV_RETURN_char_array(msg, wifi_key, 12,  32);
}

/**
 * @brief Decode a hubsan_set_wifi message into a struct
 *
 * @param msg The message to decode
 * @param hubsan_set_wifi C-struct to decode the message contents into
 */
static inline void mavlink_msg_hubsan_set_wifi_decode(const mavlink_message_t* msg, mavlink_hubsan_set_wifi_t* hubsan_set_wifi)
{
#if MAVLINK_NEED_BYTE_SWAP
	hubsan_set_wifi->target_system = mavlink_msg_hubsan_set_wifi_get_target_system(msg);
	hubsan_set_wifi->target_component = mavlink_msg_hubsan_set_wifi_get_target_component(msg);
	mavlink_msg_hubsan_set_wifi_get_wifi_ssid(msg, hubsan_set_wifi->wifi_ssid);
	mavlink_msg_hubsan_set_wifi_get_wifi_key(msg, hubsan_set_wifi->wifi_key);
#else
	memcpy(hubsan_set_wifi, _MAV_PAYLOAD(msg), MAVLINK_MSG_ID_HUBSAN_SET_WIFI_LEN);
#endif
}

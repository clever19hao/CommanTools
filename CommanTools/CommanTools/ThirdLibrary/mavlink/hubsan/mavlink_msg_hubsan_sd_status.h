// MESSAGE HUBSAN_SD_STATUS PACKING

#define MAVLINK_MSG_ID_HUBSAN_SD_STATUS 57

typedef struct __mavlink_hubsan_sd_status_t
{
 float sd_capacity; ///< SD card capacity,size in MB
 float sd_surplus; ///< SD card surplus capacity,size in MB
 uint8_t target_system; ///< System ID
 uint8_t target_component; ///< Component ID
 uint8_t sd_status; ///< sd card status,as defined by MAV_SD_STATUS enum
} mavlink_hubsan_sd_status_t;

#define MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN 11
#define MAVLINK_MSG_ID_57_LEN 11

#define MAVLINK_MSG_ID_HUBSAN_SD_STATUS_CRC 229
#define MAVLINK_MSG_ID_57_CRC 229



#define MAVLINK_MESSAGE_INFO_HUBSAN_SD_STATUS { \
	"HUBSAN_SD_STATUS", \
	5, \
	{  { "sd_capacity", NULL, MAVLINK_TYPE_FLOAT, 0, 0, offsetof(mavlink_hubsan_sd_status_t, sd_capacity) }, \
         { "sd_surplus", NULL, MAVLINK_TYPE_FLOAT, 0, 4, offsetof(mavlink_hubsan_sd_status_t, sd_surplus) }, \
         { "target_system", NULL, MAVLINK_TYPE_UINT8_T, 0, 8, offsetof(mavlink_hubsan_sd_status_t, target_system) }, \
         { "target_component", NULL, MAVLINK_TYPE_UINT8_T, 0, 9, offsetof(mavlink_hubsan_sd_status_t, target_component) }, \
         { "sd_status", NULL, MAVLINK_TYPE_UINT8_T, 0, 10, offsetof(mavlink_hubsan_sd_status_t, sd_status) }, \
         } \
}


/**
 * @brief Pack a hubsan_sd_status message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 *
 * @param target_system System ID
 * @param target_component Component ID
 * @param sd_status sd card status,as defined by MAV_SD_STATUS enum
 * @param sd_capacity SD card capacity,size in MB
 * @param sd_surplus SD card surplus capacity,size in MB
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_hubsan_sd_status_pack(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg,
						       uint8_t target_system, uint8_t target_component, uint8_t sd_status, float sd_capacity, float sd_surplus)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN];
	_mav_put_float(buf, 0, sd_capacity);
	_mav_put_float(buf, 4, sd_surplus);
	_mav_put_uint8_t(buf, 8, target_system);
	_mav_put_uint8_t(buf, 9, target_component);
	_mav_put_uint8_t(buf, 10, sd_status);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN);
#else
	mavlink_hubsan_sd_status_t packet;
	packet.sd_capacity = sd_capacity;
	packet.sd_surplus = sd_surplus;
	packet.target_system = target_system;
	packet.target_component = target_component;
	packet.sd_status = sd_status;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN);
#endif

	msg->msgid = MAVLINK_MSG_ID_HUBSAN_SD_STATUS;
#if MAVLINK_CRC_EXTRA
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_CRC);
#else
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN);
#endif
}

/**
 * @brief Pack a hubsan_sd_status message on a channel
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param target_system System ID
 * @param target_component Component ID
 * @param sd_status sd card status,as defined by MAV_SD_STATUS enum
 * @param sd_capacity SD card capacity,size in MB
 * @param sd_surplus SD card surplus capacity,size in MB
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_hubsan_sd_status_pack_chan(uint8_t system_id, uint8_t component_id, uint8_t chan,
							   mavlink_message_t* msg,
						           uint8_t target_system,uint8_t target_component,uint8_t sd_status,float sd_capacity,float sd_surplus)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN];
	_mav_put_float(buf, 0, sd_capacity);
	_mav_put_float(buf, 4, sd_surplus);
	_mav_put_uint8_t(buf, 8, target_system);
	_mav_put_uint8_t(buf, 9, target_component);
	_mav_put_uint8_t(buf, 10, sd_status);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN);
#else
	mavlink_hubsan_sd_status_t packet;
	packet.sd_capacity = sd_capacity;
	packet.sd_surplus = sd_surplus;
	packet.target_system = target_system;
	packet.target_component = target_component;
	packet.sd_status = sd_status;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN);
#endif

	msg->msgid = MAVLINK_MSG_ID_HUBSAN_SD_STATUS;
#if MAVLINK_CRC_EXTRA
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_CRC);
#else
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN);
#endif
}

/**
 * @brief Encode a hubsan_sd_status struct
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 * @param hubsan_sd_status C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_hubsan_sd_status_encode(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg, const mavlink_hubsan_sd_status_t* hubsan_sd_status)
{
	return mavlink_msg_hubsan_sd_status_pack(system_id, component_id, msg, hubsan_sd_status->target_system, hubsan_sd_status->target_component, hubsan_sd_status->sd_status, hubsan_sd_status->sd_capacity, hubsan_sd_status->sd_surplus);
}

/**
 * @brief Encode a hubsan_sd_status struct on a channel
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param hubsan_sd_status C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_hubsan_sd_status_encode_chan(uint8_t system_id, uint8_t component_id, uint8_t chan, mavlink_message_t* msg, const mavlink_hubsan_sd_status_t* hubsan_sd_status)
{
	return mavlink_msg_hubsan_sd_status_pack_chan(system_id, component_id, chan, msg, hubsan_sd_status->target_system, hubsan_sd_status->target_component, hubsan_sd_status->sd_status, hubsan_sd_status->sd_capacity, hubsan_sd_status->sd_surplus);
}

/**
 * @brief Send a hubsan_sd_status message
 * @param chan MAVLink channel to send the message
 *
 * @param target_system System ID
 * @param target_component Component ID
 * @param sd_status sd card status,as defined by MAV_SD_STATUS enum
 * @param sd_capacity SD card capacity,size in MB
 * @param sd_surplus SD card surplus capacity,size in MB
 */
#ifdef MAVLINK_USE_CONVENIENCE_FUNCTIONS

static inline void mavlink_msg_hubsan_sd_status_send(mavlink_channel_t chan, uint8_t target_system, uint8_t target_component, uint8_t sd_status, float sd_capacity, float sd_surplus)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN];
	_mav_put_float(buf, 0, sd_capacity);
	_mav_put_float(buf, 4, sd_surplus);
	_mav_put_uint8_t(buf, 8, target_system);
	_mav_put_uint8_t(buf, 9, target_component);
	_mav_put_uint8_t(buf, 10, sd_status);

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SD_STATUS, buf, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SD_STATUS, buf, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN);
#endif
#else
	mavlink_hubsan_sd_status_t packet;
	packet.sd_capacity = sd_capacity;
	packet.sd_surplus = sd_surplus;
	packet.target_system = target_system;
	packet.target_component = target_component;
	packet.sd_status = sd_status;

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SD_STATUS, (const char *)&packet, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SD_STATUS, (const char *)&packet, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN);
#endif
#endif
}

#if MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN <= MAVLINK_MAX_PAYLOAD_LEN
/*
  This varient of _send() can be used to save stack space by re-using
  memory from the receive buffer.  The caller provides a
  mavlink_message_t which is the size of a full mavlink message. This
  is usually the receive buffer for the channel, and allows a reply to an
  incoming message with minimum stack space usage.
 */
static inline void mavlink_msg_hubsan_sd_status_send_buf(mavlink_message_t *msgbuf, mavlink_channel_t chan,  uint8_t target_system, uint8_t target_component, uint8_t sd_status, float sd_capacity, float sd_surplus)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char *buf = (char *)msgbuf;
	_mav_put_float(buf, 0, sd_capacity);
	_mav_put_float(buf, 4, sd_surplus);
	_mav_put_uint8_t(buf, 8, target_system);
	_mav_put_uint8_t(buf, 9, target_component);
	_mav_put_uint8_t(buf, 10, sd_status);

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SD_STATUS, buf, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SD_STATUS, buf, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN);
#endif
#else
	mavlink_hubsan_sd_status_t *packet = (mavlink_hubsan_sd_status_t *)msgbuf;
	packet->sd_capacity = sd_capacity;
	packet->sd_surplus = sd_surplus;
	packet->target_system = target_system;
	packet->target_component = target_component;
	packet->sd_status = sd_status;

#if MAVLINK_CRC_EXTRA
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SD_STATUS, (const char *)packet, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_CRC);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_HUBSAN_SD_STATUS, (const char *)packet, MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN);
#endif
#endif
}
#endif

#endif

// MESSAGE HUBSAN_SD_STATUS UNPACKING


/**
 * @brief Get field target_system from hubsan_sd_status message
 *
 * @return System ID
 */
static inline uint8_t mavlink_msg_hubsan_sd_status_get_target_system(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  8);
}

/**
 * @brief Get field target_component from hubsan_sd_status message
 *
 * @return Component ID
 */
static inline uint8_t mavlink_msg_hubsan_sd_status_get_target_component(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  9);
}

/**
 * @brief Get field sd_status from hubsan_sd_status message
 *
 * @return sd card status,as defined by MAV_SD_STATUS enum
 */
static inline uint8_t mavlink_msg_hubsan_sd_status_get_sd_status(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  10);
}

/**
 * @brief Get field sd_capacity from hubsan_sd_status message
 *
 * @return SD card capacity,size in MB
 */
static inline float mavlink_msg_hubsan_sd_status_get_sd_capacity(const mavlink_message_t* msg)
{
	return _MAV_RETURN_float(msg,  0);
}

/**
 * @brief Get field sd_surplus from hubsan_sd_status message
 *
 * @return SD card surplus capacity,size in MB
 */
static inline float mavlink_msg_hubsan_sd_status_get_sd_surplus(const mavlink_message_t* msg)
{
	return _MAV_RETURN_float(msg,  4);
}

/**
 * @brief Decode a hubsan_sd_status message into a struct
 *
 * @param msg The message to decode
 * @param hubsan_sd_status C-struct to decode the message contents into
 */
static inline void mavlink_msg_hubsan_sd_status_decode(const mavlink_message_t* msg, mavlink_hubsan_sd_status_t* hubsan_sd_status)
{
#if MAVLINK_NEED_BYTE_SWAP
	hubsan_sd_status->sd_capacity = mavlink_msg_hubsan_sd_status_get_sd_capacity(msg);
	hubsan_sd_status->sd_surplus = mavlink_msg_hubsan_sd_status_get_sd_surplus(msg);
	hubsan_sd_status->target_system = mavlink_msg_hubsan_sd_status_get_target_system(msg);
	hubsan_sd_status->target_component = mavlink_msg_hubsan_sd_status_get_target_component(msg);
	hubsan_sd_status->sd_status = mavlink_msg_hubsan_sd_status_get_sd_status(msg);
#else
	memcpy(hubsan_sd_status, _MAV_PAYLOAD(msg), MAVLINK_MSG_ID_HUBSAN_SD_STATUS_LEN);
#endif
}

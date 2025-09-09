using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Settings
{
    /// <summary>
    /// Data Transfer Object for active user session information
    /// </summary>
    public class ActiveSessionDTO
    {
        /// <summary>
        /// Gets or sets the unique identifier of the session
        /// </summary>
        public Guid Id { get; set; }

        /// <summary>
        /// Gets or sets the device information for the session
        /// </summary>
        public string DeviceInfo { get; set; }

        /// <summary>
        /// Gets or sets the location information for the session
        /// </summary>
        public string Location { get; set; }

        /// <summary>
        /// Gets or sets the login time of the session
        /// </summary>
        public DateTime LoginTime { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this is the current session
        /// </summary>
        public bool IsCurrent { get; set; }
    }
}

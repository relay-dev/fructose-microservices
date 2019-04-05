﻿using System;
using System.Collections.Generic;

namespace Customer.Domain.Entity
{
    public partial class CustomerSearchTermType
    {
        public CustomerSearchTermType()
        {
            CustomerSearch = new HashSet<CustomerSearch>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string DisplayName { get; set; }
        public int? DisplayOrder { get; set; }
        public bool? IsActive { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public byte[] RowVersion { get; set; }

        public virtual ICollection<CustomerSearch> CustomerSearch { get; set; }
    }
}

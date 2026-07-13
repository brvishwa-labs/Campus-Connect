/**
 * useHolidays — fetches and caches college holidays for the current academic year.
 *
 * Returns:
 *   holidays   - array of { id, date (string "YYYY-MM-DD"), name }
 *   loading    - boolean
 *   isHoliday  - (dateStr: string) => boolean
 *   getHolidayName - (dateStr: string) => string | null
 *   refetch    - () => void
 */

import { useState, useEffect, useCallback } from 'react';
import axios from 'axios';

/** Returns true if a JS Date object is a Sunday. */
export const isSunday = (dateStr) => {
  const d = new Date(dateStr + 'T00:00:00');
  return d.getDay() === 0;
};

export const useHolidays = () => {
  const [holidays, setHolidays] = useState([]);
  const [loading, setLoading] = useState(true);
  const [yearBounds, setYearBounds] = useState({ start: null, end: null });

  const fetchHolidays = useCallback(() => {
    setLoading(true);
    axios
      .get('/api/admin/holidays')
      .then((r) => {
        setHolidays(r.data.holidays || []);
        setYearBounds({
          start: r.data.academic_year_start,
          end: r.data.academic_year_end,
        });
      })
      .catch(() => setHolidays([]))
      .finally(() => setLoading(false));
  }, []);

  useEffect(() => {
    fetchHolidays();
  }, [fetchHolidays]);

  /** Build a Set of holiday date strings for O(1) lookup */
  const holidayMap = holidays.reduce((acc, h) => {
    acc[h.date] = h.name;
    return acc;
  }, {});

  const isHoliday = useCallback(
    (dateStr) => {
      if (!dateStr) return false;
      return isSunday(dateStr) || dateStr in holidayMap;
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [holidays]
  );

  const getHolidayName = useCallback(
    (dateStr) => {
      if (!dateStr) return null;
      if (holidayMap[dateStr]) return holidayMap[dateStr];
      if (isSunday(dateStr)) return 'Sunday';
      return null;
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [holidays]
  );

  return { holidays, loading, isHoliday, getHolidayName, refetch: fetchHolidays, yearBounds };
};

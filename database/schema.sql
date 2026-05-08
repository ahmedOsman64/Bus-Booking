-- Create tables for BUS BOOKING system

-- 1. Profiles (linked to Supabase Auth users)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone_number TEXT,
    role TEXT CHECK (role IN ('passenger', 'driver', 'admin')) DEFAULT 'passenger',
    status TEXT CHECK (status IN ('active', 'inactive')) DEFAULT 'active',
    admin_category TEXT,
    profile_image TEXT,
    last_active TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Buses
CREATE TABLE IF NOT EXISTS public.buses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bus_number TEXT UNIQUE NOT NULL,
    plate_number TEXT UNIQUE NOT NULL,
    total_seats INTEGER NOT NULL,
    bus_type TEXT NOT NULL, -- e.g., 'Luxury', 'Standard'
    status TEXT CHECK (status IN ('Available', 'On Trip', 'Maintenance')) DEFAULT 'Available',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Routes
CREATE TABLE IF NOT EXISTS public.routes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    origin TEXT NOT NULL,
    destination TEXT NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    estimated_duration INTERVAL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Trips (Specific instances of a route)
CREATE TABLE IF NOT EXISTS public.trips (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    route_id UUID REFERENCES public.routes(id) ON DELETE CASCADE,
    bus_id UUID REFERENCES public.buses(id) ON DELETE SET NULL,
    departure_time TIMESTAMP WITH TIME ZONE NOT NULL,
    arrival_time TIMESTAMP WITH TIME ZONE,
    status TEXT CHECK (status IN ('scheduled', 'on-going', 'completed', 'cancelled')) DEFAULT 'scheduled',
    price DECIMAL(10, 2), -- Overrides route price if set
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Bookings
CREATE TABLE IF NOT EXISTS public.bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID REFERENCES public.trips(id) ON DELETE CASCADE,
    passenger_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    passenger_name TEXT NOT NULL,
    passenger_phone TEXT NOT NULL,
    seat_numbers INTEGER[] NOT NULL,
    total_fare DECIMAL(10, 2) NOT NULL,
    status TEXT CHECK (status IN ('pending', 'confirmed', 'cancelled')) DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.buses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trips ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

-- Basic Policies
-- 1. Profiles
CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (true); -- Usually true for basic info, but let's restrict if needed
-- To be stricter:
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles;
CREATE POLICY "Users can view their own profile." ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Admins can view all profiles." ON public.profiles FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
);
CREATE POLICY "Users can update their own profile." ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- 2. Buses
CREATE POLICY "Buses are viewable by everyone." ON public.buses FOR SELECT USING (true);
CREATE POLICY "Only admins can modify buses." ON public.buses FOR ALL USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
);

-- 3. Routes
CREATE POLICY "Routes are viewable by everyone." ON public.routes FOR SELECT USING (true);
CREATE POLICY "Only admins can modify routes." ON public.routes FOR ALL USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
);

-- 4. Trips
CREATE POLICY "Trips are viewable by everyone." ON public.trips FOR SELECT USING (true);
CREATE POLICY "Only admins can modify trips." ON public.trips FOR ALL USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
);

-- 5. Bookings
CREATE POLICY "Users can view their own bookings." ON public.bookings FOR SELECT USING (auth.uid() = passenger_id);
CREATE POLICY "Admins can view all bookings." ON public.bookings FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
);
CREATE POLICY "Users can create their own bookings." ON public.bookings FOR INSERT WITH CHECK (auth.uid() = passenger_id);
CREATE POLICY "Only admins can delete bookings." ON public.bookings FOR DELETE USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
);

-- 6. Performance Indexes (For 10,000+ users)
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);
CREATE INDEX IF NOT EXISTS idx_profiles_role ON public.profiles(role);
CREATE INDEX IF NOT EXISTS idx_buses_status ON public.buses(status);
CREATE INDEX IF NOT EXISTS idx_trips_departure ON public.trips(departure_time);
CREATE INDEX IF NOT EXISTS idx_trips_route_id ON public.trips(route_id);
CREATE INDEX IF NOT EXISTS idx_bookings_passenger_id ON public.bookings(passenger_id);
CREATE INDEX IF NOT EXISTS idx_bookings_trip_id ON public.bookings(trip_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON public.bookings(status);
